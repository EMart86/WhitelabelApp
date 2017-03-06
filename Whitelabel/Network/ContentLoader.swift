//
//  ContentLoader.swift
//  Whitelabel
//
//  Created by Martin Eberl on 27.02.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SystemConfiguration

enum Response {
    case success([Content])
    case fail(Error)
}

class ContentLoader {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var isInternetAvailable: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func load(contentResponse: @escaping (Response) -> Void) {
        guard isInternetAvailable else {
            contentResponse(.fail(NSError(domain: "ContentLoader", code: -1, userInfo: [NSLocalizedDescriptionKey: "Keine Internetverbindung"])))
            return
        }
        Alamofire.request(url).responseArray { (response: DataResponse<[Content]>) in
            switch response.result {
            case .success(let content):
                contentResponse(.success(content))
                break
            case .failure(let error):
                contentResponse(.fail(error))
                break
            }
        }
    }
}
