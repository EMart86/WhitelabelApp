//
//  TimeStore.swift
//  Whitelabel
//
//  Created by Martin Eberl on 16.04.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

final class TimeStore: ManagedObjectStore<Time> {
    init() {
        super.init(storage: SqliteStorage<Time>("TimeModel").createProvider(), entity: Time.self, predicate: nil, sortDescriptors: [NSSortDescriptor(key: "value", ascending: true)])
    }
}
