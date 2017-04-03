//
//  Dependencies.swift
//  Whitelabel
//
//  Created by Martin Eberl on 27.02.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

class Dependencies {
    static let shared = Dependencies()
    
    let loader: ContentLoader?
    let locationProvider: LocationProvider?
    
    private init() {
        if let urlString = Bundle.main.infoDictionary?["LOAD_PATH"] as? String,
            let url = URL(string: urlString) {
            loader = ContentLoader(url: url)
        } else {
            loader = nil
        }
        
        locationProvider = LocationProvider()
    }
}
