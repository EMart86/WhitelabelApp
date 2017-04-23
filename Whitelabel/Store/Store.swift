//
//  Store.swift
//  Whitelabel
//
//  Created by Martin Eberl on 04.04.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

protocol Store {
    var models: Observable<[StoreModel]>? { get }
    var storage: Storage { get }
    
    func add(model: StoreModel)
    func remove(model: StoreModel)
}

extension Store {
    func add(model: StoreModel) {
        storage.insert(model: model)
        storage.commit()
    }
    
    func remove(model: StoreModel) {
        storage.remove(model: model)
        storage.commit()
    }
}

protocol StoreModel {
}

struct ObjectStore: Store {
    private(set) var storage: Storage
    private(set) var models: Observable<[StoreModel]>? = nil
    
    init(storage: Storage) {
        self.storage = storage
        models = storage.createObservable(predicate: nil, sortDescriptors: nil)
    }
}
