//
//  String+HTML.swift
//  Golfclub-liebenau
//
//  Created by Martin Eberl on 11.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

extension String {
    
    var trimmingHTMLTags: String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
