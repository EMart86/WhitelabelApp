//
//  Storage.swift
//  Whitelabel
//
//  Created by Martin Eberl on 04.04.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

protocol Query {
}
open class ObjectProvider {
    func observable<ObservableValue>(where query: Query) -> Observable<[ObservableValue]>? {
        return nil
    }
}

protocol Storage {
    var provider: ObjectProvider { get }
    func insert(model: Any)
    func remove(model: Any)
    func commit()
    func rollback()
}
