//
//  TimeStore.swift
//  Whitelabel
//
//  Created by Martin Eberl on 16.04.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

struct TimeStore: Store {
    internal var storage: Storage
    internal var models: Observable<[Any]>?

    
}
