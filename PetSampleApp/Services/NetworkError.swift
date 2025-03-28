//
//  NetworkError.swift
//  PetSampleApp
//
//  Created by Alin Stanusescu on 27.03.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
}
