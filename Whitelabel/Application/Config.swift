//
//  Config.swift
//  Whitelabel
//
//  Created by Martin Eberl on 10.06.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

final class Config {
    
    static var configDictionary: [String: Any]? {
        return Bundle.main.infoDictionary?["CONFIG"] as? [String: Any]
    }
    
    static var primaryAppColorHex: String? {
        return configDictionary?["PRIMARY_APP_COLOR"] as? String
    }
    
    static var apiBasePath: String? {
        return configDictionary?["API_BASE_PATH"] as? String
    }
}
