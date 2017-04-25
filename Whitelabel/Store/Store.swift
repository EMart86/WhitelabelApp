//
//  Store.swift
//  Whitelabel
//
//  Created by Martin Eberl on 04.04.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

protocol Store {
    func models<T>() -> Observable<[T]>?
    var storage: Storage { get }
    
    func add(model: Any)
    func remove(model: Any)
}

extension Store {
    func add(model: Any) {
        storage.insert(model: model)
        storage.commit()
    }
    
    func remove(model: Any) {
        storage.remove(model: model)
        storage.commit()
    }
}
