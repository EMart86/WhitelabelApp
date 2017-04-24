//
//  Store.swift
//  Whitelabel
//
//  Created by Martin Eberl on 04.04.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

protocol Store {
    var models: Observable<[Any]>? { get }
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

struct ObjectStore: Store {
    private(set) var storage: Storage
    private(set) var models: Observable<[Any]>? = nil
    
    init(storage: Storage) {
        self.storage = storage
    }
}
