//
//  NetworkService.swift
//  PetSampleApp
//
//  Created by Alin Stanusescu on 27.03.2025.
//

import Foundation
import RxSwift
import RxCocoa

protocol NetworkServiceProtocol {
    /// Fetches a list of animals from the API.
    /// - Returns: An Observable emitting an array of Animal.
    func fetchAnimals() -> Observable<[Animal]>

    /// Fetches an access token using API credentials.
    /// - Returns: An Observable emitting the access token as a String.
    func fetchAccessToken() -> Observable<String>
}

final class NetworkService: NetworkServiceProtocol {

    enum Constants {
        static let baseURL = "https://api.petfinder.com/"
        static let animalEndpoint = "v2/animals"

        static let apiKey = "8FvB92COL3loJkRHBozGPLOVKZTG4CgXal6Dou6EjsH5lj2SXB"
        static let apiSecret = "zcYSA3CrhG6yW1dc539o8rAVgj7ecwLUaYHTSe3s"
    }
    
    private let disposeBag = DisposeBag()

    private var accessToken: String?
    private var tokenExpirationDate: Date?

    func fetchAnimals() -> Observable<[Animal]> {
        return ensureValidToken()
            .flatMap { token -> Observable<(response: HTTPURLResponse, data: Data)> in
                let url = URL(string: Constants.baseURL + Constants.animalEndpoint)!
                var request = URLRequest(url: url)

                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                return URLSession.shared.rx.response(request: request)
            }
            .flatMap { response, data -> Observable<[Animal]> in

                guard (200..<300).contains(response.statusCode) else {
                    return Observable.error(NetworkError.serverError("Status code: \(response.statusCode)"))
                }

                /// Check if we got a 401 Unauthorized error (expired token)
                if response.statusCode == 401 {
                    /// Clear the current token and try again with a fresh token
                    self.accessToken = nil
                    self.tokenExpirationDate = nil

                    return self.ensureValidToken()
                        .flatMap { _ in self.fetchAnimals() }
                }

                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(PetfinderResponse.self, from: data)
                    return Observable.just(response.animals)
                } catch {
                    return Observable.error(NetworkError.decodingError)
                }
            }
            .catch { error in
                print("Error fetching animals: \(error)")
                return Observable.error(error)
            }
    }

    private func ensureValidToken() -> Observable<String> {
        if let token = accessToken, let expirationDate = tokenExpirationDate, expirationDate > Date() {
            return Observable.just(token)
        }

        return fetchAccessToken()
    }

    /// Fetch access token using API Key and Secret
    func fetchAccessToken() -> Observable<String> {
        let url = URL(string: "https://api.petfinder.com/v2/oauth2/token")!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        let body = "grant_type=client_credentials&client_id=\(Constants.apiKey)&client_secret=\(Constants.apiSecret)"
        request.httpBody = body.data(using: .utf8)

        return URLSession.shared.rx.response(request: request)
            .map { _, data in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                    if let expiresIn = tokenResponse.expiresIn {
                        self.tokenExpirationDate = Date().addingTimeInterval(TimeInterval(expiresIn - 60))
                    }

                    self.accessToken = tokenResponse.accessToken
                    return tokenResponse.accessToken
                } catch {
                    throw error
                }
            }
    }
}
