//
//  Storage.swift
//  Whitelabel
//
//  Created by Martin Eberl on 04.04.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

protocol Storage {
    func createObservable(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Observable<[StoreModel]>
    func insert(model: StoreModel)
    func remove(model: StoreModel)
    func commit()
    func rollback()
}
