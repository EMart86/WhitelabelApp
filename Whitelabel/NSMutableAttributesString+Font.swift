//
//  NSMutableAttributesString+FontS.swift
//  Golfclub-liebenau
//
//  Created by Martin Eberl on 24.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    /// Replaces the base font (typically Times) with the given font, while preserving traits like bold and italic
    func setBaseFont(baseFont: UIFont, preserveFontSizes: Bool = false) {
        let baseDescriptor = baseFont.fontDescriptor
        beginEditing()
        enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, length), options: []) { object, range, stop in
            if let font = object as? UIFont {
                // Instantiate a font with our base font's family, but with the current range's traits
                let traits = font.fontDescriptor.symbolicTraits
                if let descriptor = baseDescriptor.withSymbolicTraits(traits) {
                    let newFont = UIFont(descriptor: descriptor, size: preserveFontSizes ? descriptor.pointSize : baseDescriptor.pointSize)
                    removeAttribute(NSFontAttributeName, range: range)
                    addAttribute(NSFontAttributeName, value: newFont, range: range)
                }
            }
        }
        endEditing()
    }
}
