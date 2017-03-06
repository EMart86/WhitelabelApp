//
//  MapViewModel.swift
//  Whitelabel
//
//  Created by Martin Eberl on 05.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation
import CoreLocation

final class MapViewModel: MapViewModelProtocol {
    let contents: [Content]
    let centerCoordinate: CLLocationCoordinate2D?
    let showUserCoordinate: Bool
    
    init(contents: [Content], centerCoordinate: CLLocationCoordinate2D? = nil, showUserCoordinate: Bool = true) {
        self.contents = contents
        self.centerCoordinate = centerCoordinate
        self.showUserCoordinate = showUserCoordinate
    }
}
