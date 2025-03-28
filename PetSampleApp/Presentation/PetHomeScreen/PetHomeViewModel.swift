//
//  PetHomeViewModel.swift
//  PetSampleApp
//
//  Created by Alin Stanusescu on 27.03.2025.
//

import Foundation
import RxSwift
import RxCocoa

class PetHomeViewModel {
    private let petService: NetworkService
    let animals = BehaviorRelay<[Animal]>(value: [])
    let error = PublishRelay<String>()
    private let disposeBag = DisposeBag()

    init(service: NetworkService = NetworkService()) {
        self.petService = service
    }

    func fetchAnimals() {
        petService.fetchAnimals()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] animals in
                self?.animals.accept(animals)
            }, onError: { [weak self] error in
                var errorMessage = "genericErrorMessage".localized
                if let networkError = error as? NetworkError {
                    switch networkError {
                    case .invalidURL:
                        errorMessage = "invalid_url".localized
                    case .invalidResponse:
                        errorMessage = "invalid_server_response".localized
                    case .decodingError:
                        errorMessage = "error_decoding_data".localized
                    case .serverError(let message):
                        errorMessage = "server_error_message".localized(with:message)
                    }
                } else {
                    errorMessage = error.localizedDescription
                }
                self?.error.accept(errorMessage)
                print("Fetching animals failed: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
