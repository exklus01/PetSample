//
//  PetDetailView.swift
//  PetSampleApp
//
//  Created by Alin Stanusescu on 27.03.2025.
//

import SwiftUI

struct PetDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: PetDetailViewModel

    init(animal: Animal) {
        self.viewModel = PetDetailViewModel(animal: animal)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PetDetailViewConfig.itemsPadding) {
                if let imageUrlString = viewModel.imageUrlString,
                   let imageUrl = URL(string: imageUrlString) {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: PetDetailViewConfig.profileImagHeight)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .frame(height: PetDetailViewConfig.profileImagHeight)
                                .clipped()
                        case .failure:
                            Color.gray
                                .frame(maxWidth: .infinity)
                                .frame(height: PetDetailViewConfig.profileImagHeight)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                Group {
                    Text(viewModel.localizedName)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(viewModel.localizedBreed)
                    Text(viewModel.localizedSize)
                    Text(viewModel.localizedGender)
                    Text(viewModel.localizedStatus)
                    Text(viewModel.localizedAge)
                    Text(viewModel.localizedPhoneNo)
                    Text(viewModel.localizedDistance)
                    Text(viewModel.localizedDescription)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationBarTitle(Text(viewModel.nameToDisplay), displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("X")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

// MARK: - Config
struct PetDetailViewConfig {
    static let profileImagHeight: CGFloat = 200
    static let itemsPadding: CGFloat = 16
}


// MARK: - Previews
struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyAnimal = Animal(
            id: 1,
            name: "Buddy",
            breeds: Breeds(primary: "Labrador", secondary: nil, mixed: false, unknown: false),
            size: "Medium",
            gender: "Male",
            status: "Adoptable",
            distance: "5 miles",
            organizationId: nil,
            url: nil,
            type: nil,
            species: nil,
            colors: nil,
            age: "Adult",
            coat: nil,
            attributes: nil,
            tags: nil,
            description: "A friendly pet looking for a new home.",
            organizationAnimalId: nil,
            photos: nil,
            primaryPhotoCropped: nil,
            statusChangedAt: "",
            publishedAt: "",
            contact: nil
        )
        return NavigationView {
            PetDetailView(animal: dummyAnimal)
        }
    }
}
