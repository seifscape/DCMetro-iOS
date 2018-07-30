//
//  RailsRouter.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 7/29/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

enum MetroRailsEndpoint {
    case getRails
}

class RailsRouter: BaseRouter {
    
    var endpoint: MetroRailsEndpoint
    init(endpoint: MetroRailsEndpoint) {
        self.endpoint = endpoint
    }
    
    override var method: Alamofire.HTTPMethod {
        switch endpoint {
        case .getRails: return .get
        }
    }
    override var path: String {
        switch endpoint {
        case .getRails: return "/Rail.svc/json/jLines"
        }
    }
    
    override var parameters: APIParams {
        switch endpoint {
        case .getRails:
            return nil
        }
    }
}
