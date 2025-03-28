//
//  PetDetailViewModel.swift
//  PetSampleApp
//
//  Created by Alin Stanusescu on 27.03.2025.
//

import SwiftUI

final class PetDetailViewModel: ObservableObject {

    let animal: Animal

    init(animal: Animal) {
        self.animal = animal
    }

    var imageUrlString: String? {
        return animal.primaryPhotoCropped?.medium ?? ""
    }

    var nameToDisplay: String {
        return self.animal.name
    }

    var localizedName: String {
        return "pet_name".localized(with: animal.name)
    }

    var localizedBreed: String {
        return "pet_breed".localized(with: animal.breeds.primary ?? "")
    }

    var localizedSize: String {
        return "pet_size".localized(with: animal.size ?? "")
    }

    var localizedGender: String {
        return "pet_gender".localized(with: animal.gender ?? "")
    }

    var localizedStatus: String {
        return "pet_status".localized(with: animal.status ?? "")
    }

    var localizedAge: String {
        return "pet_age".localized(with: animal.age ?? "")
    }

    var localizedPhoneNo: String {
        return "pet_phone_no".localized(with: animal.contact?.phone ?? "")
    }

    var localizedDistance: String {
        return "pet_distance".localized(with: animal.distance ?? "")
    }

    var localizedDescription: String {
        return "pet_description".localized(with: animal.description ?? "")
    }
}
