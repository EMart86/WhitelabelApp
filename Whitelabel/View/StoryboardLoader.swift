//
//  StoryboardLoader.swift
//  Whitelabel
//
//  Created by Martin Eberl on 05.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import UIKit

enum StoryboardLoader {
    struct Content {
        let storyboardName: String
        let storyboardId: String
    }
    
    case MapView
    case ListView
    case Detail
    
    var content: Content {
        switch self {
        case .MapView:
            return Content(storyboardName: "MapView", storyboardId: "MapViewController")
        case .ListView:
            return Content(storyboardName: "ListView", storyboardId: "MasterViewController")
        case .Detail:
            return Content(storyboardName: "Detail", storyboardId: "DetailViewController")
        }
    }
}

extension StoryboardLoader {
    func createViewController<T: UIViewController>() -> T {
        return UIStoryboard(name: content.storyboardName, bundle: nil).instantiateViewController(withIdentifier: content.storyboardId) as! T
    }
}

