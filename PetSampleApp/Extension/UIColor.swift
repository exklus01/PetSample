//
//  Untitled.swift
//  PetSampleApp
//
//  Created by Alin Stanusescu on 27.03.2025.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
         var hexNormalized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
         if hexNormalized.hasPrefix("#") {
             hexNormalized.remove(at: hexNormalized.startIndex)
         }
         guard hexNormalized.count == 6 else { return nil }
         var rgbValue: UInt64 = 0
         Scanner(string: hexNormalized).scanHexInt64(&rgbValue)
         let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
         let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
         let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
         self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
