//
//  String.swift
//  PetSampleApp
//
//  Created by Alin Stanusescu on 27.03.2025.
//

import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localized(with arguments: CVarArg...) -> String {
        String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}
