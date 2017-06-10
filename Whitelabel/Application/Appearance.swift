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
        defaultColor = UIColor.primaryColor
    }
}
