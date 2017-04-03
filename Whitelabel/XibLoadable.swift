//
//  XibLoadable.swift
//  Golfclub-liebenau
//
//  Created by Martin Eberl on 01.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit

protocol XibLoadable {
    static var xibName: String { get }
}

extension XibLoadable {
    static func nib() -> UINib {
        return UINib(nibName: xibName, bundle: nil)
    }
    
    static func view(owner: Any? = nil, options: [AnyHashable: Any]? = nil) -> UIView? {
        return Bundle.main.loadNibNamed(xibName,
                                        owner: owner,
                                        options: options)?.first as? UIView
    }
}

extension UITableView {
    func registerCell(xibLoadable: XibLoadable.Type) {
        register(xibLoadable.nib(), forCellReuseIdentifier: xibLoadable.xibName)
    }
    
    func dequeueCell<T: XibLoadable>(at indexPath: IndexPath? = nil) -> T? {
        if let indexPath = indexPath {
            return dequeueReusableCell(withIdentifier: T.xibName, for: indexPath) as? T
        } else {
            return dequeueReusableCell(withIdentifier: T.xibName) as? T
        }
    }
    
    func registerHeaderFooterView(xibLoadable: XibLoadable.Type) {
        register(xibLoadable.nib(), forHeaderFooterViewReuseIdentifier: xibLoadable.xibName)
    }
    
    func dequeueHeaderFooterView(_ xibLoadable: XibLoadable.Type) -> XibLoadable? {
        return dequeueReusableHeaderFooterView(withIdentifier: xibLoadable.xibName) as? XibLoadable
    }
}
