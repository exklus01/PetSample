//
//  TokenResponse.swift
//  PetSampleApp
//
//  Created by Alin Stanusescu on 27.03.2025.
//
import Foundation

struct TokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int?
}
