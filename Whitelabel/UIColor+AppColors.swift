//
//  UIColor+AppColors.swift
//  Golfclub-liebenau
//
//  Created by Martin Eberl on 27.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit

extension UIColor {
    static var primaryColor: UIColor {
        return UIColor(hex: Config.primaryAppColorHex ?? "") ?? .white
    }
}
