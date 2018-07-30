//
//  Constants.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 7/29/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

import Foundation

struct K {
    struct APIEndpoint {
        static let baseURL = "https://api.wmata.com"
    }
    
    struct APIParameterKey {
        static let apiKey = "5567991d9d3d4faf8003a5118a5bfa25"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
