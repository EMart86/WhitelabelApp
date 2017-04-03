//
//  String+HTMLAttributedString.swift
//  Golfclub-liebenau
//
//  Created by Martin Eberl on 24.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit

extension String {
    var htmlAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf16, allowLossyConversion: false) else { return nil }
        do {
            return try NSMutableAttributedString(data: data, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
