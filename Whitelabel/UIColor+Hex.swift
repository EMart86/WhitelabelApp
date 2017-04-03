//
//  UIColor+Hex.swift
//  Golfclub-liebenau
//
//  Created by Martin Eberl on 27.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        guard let normalizedString = UIColor.normalize(string: hex) else {
            return nil
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: normalizedString).scanHexInt32(&rgbValue)
        
        var red: CGFloat? = nil
        var green: CGFloat? = nil
        var blue: CGFloat? = nil
        var alpha: CGFloat = 1
        if normalizedString.characters.count == 6 {
            red = CGFloat((rgbValue & 0xFF0000) >> 16)
            green = CGFloat((rgbValue & 0x00FF00) >> 8)
            blue = CGFloat(rgbValue & 0x0000FF)
        } else if normalizedString.characters.count == 8 {
            red = CGFloat((rgbValue & 0xFF000000) >> 32)
            green = CGFloat((rgbValue & 0x00FF0000) >> 16)
            blue = CGFloat((rgbValue & 0x0000FF00) >> 8)
            alpha = CGFloat(rgbValue & 0x000000FF)
        }
        
        guard let _red = red,
            let _green = green,
            let _blue = blue else {
                return nil
        }
        
        self.init(
            red: _red / 255.0,
            green: _green / 255.0,
            blue: _blue / 255.0,
            alpha: alpha
        )
    }
    
    private static func normalize(string: String) -> String? {
        var cString = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        return (cString.characters.count == 6 || cString.characters.count == 8) ? cString : nil
    }
}
