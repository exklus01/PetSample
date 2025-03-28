//
//  Pet.swift
//  PetSampleApp
//
//  Created by Alin Stanusescu on 27.03.2025.
//

import Foundation

struct PetfinderResponse: Codable {
    let animals: [Animal]
}

struct Animal: Codable {
    let id: Int

    let name: String
    let breeds: Breeds
    let size: String?
    let gender: String?
    let status: String?
    let distance: String?

    let organizationId: String?
    let url: String?
    let type: String?
    let species: String?
    let colors: Colors?
    let age: String?
    let coat: String?
    let attributes: Attributes?
    let tags: [String]?
    let description: String?
    let organizationAnimalId: String?
    let photos: [Photo]?
    let primaryPhotoCropped: Photo?
    let statusChangedAt: String
    let publishedAt: String
    let contact: Contact?

    enum CodingKeys: String, CodingKey {
        case id, url, type, species, age, gender, size, coat, tags, name, description, status, distance, contact
        case organizationId = "organization_id"
        case breeds, colors, attributes
        case organizationAnimalId = "organization_animal_id"
        case primaryPhotoCropped = "primary_photo_cropped"
        case statusChangedAt = "status_changed_at", publishedAt = "published_at"
        case photos
    }
}

struct Breeds: Codable {
    let primary: String?
    let secondary: String?
    let mixed: Bool?
    let unknown: Bool?
}

struct Colors: Codable {
    let primary: String?
    let secondary: String?
    let tertiary: String?
}

struct Attributes: Codable {
    let spayedNeutered: Bool?
    let houseTrained: Bool?
    let declawed: Bool?
    let specialNeeds: Bool?
    let shotsCurrent: Bool?

    enum CodingKeys: String, CodingKey {
        case spayedNeutered = "spayed_neutered"
        case houseTrained = "house_trained"
        case declawed, specialNeeds = "special_needs"
        case shotsCurrent = "shots_current"
    }
}

struct Contact: Codable {
    let email: String?
    let phone: String?
    let address: Address?
}

struct Address: Codable {
    let address1: String?
    let address2: String?
    let city: String?
    let state: String?
    let postcode: String?
    let country: String?
}

struct Photo: Codable {
    let small: String?
    let medium: String?
    let large: String?
    let full: String?
}

struct AnimalResponse: Codable {
    let animals: [Animal]?
    let pagination: Pagination?
}

struct Pagination: Codable {
    let countPerPage: Int?
    let totalCount: Int?
    let currentPage: Int?
    let totalPages: Int?
    let links: PaginationLinks?

    enum CodingKeys: String, CodingKey {
        case countPerPage = "count_per_page"
        case totalCount = "total_count"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case links
    }
}

struct PaginationLinks: Codable {
    let next: NextLink?

    struct NextLink: Codable {
        let href: String
    }
}
