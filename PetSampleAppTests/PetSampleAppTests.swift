//
//  PetSampleAppTests.swift
//  PetSampleAppTests
//
//  Created by Alin Stanusescu on 27.03.2025.
//

import Testing
import XCTest
import RxSwift
import RxCocoa
@testable import PetSampleApp

class PetSampleAppTests: XCTestCase {
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }

    func testPetServiceDecoding() {
        let jsonString = """
        {
            "animals": [
                {
                    "id": 1,
                    "name": "Buddy",
                    "breeds": {
                        "primary": "Labrador",
                        "secondary": null,
                        "mixed": false,
                        "unknown": false
                    },
                    "size": "Medium",
                    "gender": "Male",
                    "status": "Adoptable",
                    "distance": "5 miles",
                    "organization_id": null,
                    "url": null,
                    "type": null,
                    "species": null,
                    "colors": null,
                    "age": "Adult",
                    "coat": null,
                    "attributes": null,
                    "tags": null,
                    "description": "A friendly pet looking for a new home.",
                    "organization_animal_id": null,
                    "photos": null,
                    "primary_photo_cropped": null,
                    "status_changed_at": "",
                    "published_at": "",
                    "contact": null
                }
            ]
        }
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to encode JSON string")
            return
        }

        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(PetfinderResponse.self, from: jsonData)
            XCTAssertEqual(response.animals.count, 1)
            XCTAssertEqual(response.animals.first?.name, "Buddy")
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }

    // MARK: - Test AnimalViewModel with a Stubbed PetService

    /// A stubbed version of PetService that returns a dummy animal.
    ///
    class StubPetService: NetworkService {
        override func fetchAnimals() -> Observable<[Animal]> {
            let dummyAnimal = Animal(
                id: 1,
                name: "Test Animal",
                breeds: Breeds(primary: "Test Breed", secondary: nil, mixed: false, unknown: false),
                size: "Small",
                gender: "Female",
                status: "Available",
                distance: "10 miles",
                organizationId: nil,
                url: nil,
                type: "Dog",
                species: "Dog",
                colors: nil,
                age: "Young",
                coat: nil,
                attributes: nil,
                tags: nil,
                description: "A test animal",
                organizationAnimalId: "NSR-A-817",
                photos: nil,
                primaryPhotoCropped: nil,
                statusChangedAt: "2025-03-27T11:04:27+0000",
                publishedAt: "2025-03-27T11:04:26+0000",
                contact: Contact(email: "pawshancock1@gmail.com", phone: "(317) 318-9483", address: Address(address1: "1224 W. Main St.", address2: "915 Divider Natchez Trace", city: "Greenfield", state: "IN", postcode: "46140", country: "US"))
            )
            return Observable.just([dummyAnimal])
        }
    }

    func testAnimalViewModelFetchAnimals() {
        let stubService = StubPetService()
        let viewModel = PetHomeViewModel(service: stubService)
        let expectation = XCTestExpectation(description: "Fetch animals and update view model")

        // Observe changes on the animals BehaviorRelay.
        viewModel.animals
            .skip(1) // skip initial empty value
            .subscribe(onNext: { animals in
                XCTAssertEqual(animals.count, 1)

                XCTAssertEqual(animals.first?.name, "Test Animal")
                XCTAssertEqual(animals.first?.gender, "Female")
                XCTAssertEqual(animals.first?.species, "Dog")
                XCTAssertEqual(animals.first?.size, "Small")
                XCTAssertEqual(animals.first?.status, "Available")
                XCTAssertEqual(animals.first?.distance, "10 miles")

                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.fetchAnimals()
        wait(for: [expectation], timeout: 2.0)
    }
}
