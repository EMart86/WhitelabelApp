//
//  Appearance.swift
//  Golfclub-liebenau
//
//  Created by Martin Eberl on 27.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit

final class Appearance {
    static let shared = Appearance()
    
    let defaultColor: UIColor?
    
    private init() {
        if let defaultColor = Bundle.main.infoDictionary?["DEFAULT_COLOR"] as? String {
            self.defaultColor = UIColor(hex: defaultColor)
        } else {
            defaultColor = nil
        }
    }
}
