//
//  TimeStore.swift
//  Whitelabel
//
//  Created by Martin Eberl on 16.04.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

final class TimeStore: ManagedObjectStore {
    init() {
        super.init(storage: SqliteStorage<Time>(), entity: Time.self, predicate: nil, sortDescriptors: nil)
    }
}
