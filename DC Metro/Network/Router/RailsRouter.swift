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

enum MetroRailsEndpoint
{
    case getRails
    case getStations(lineCode:String)
    case getPathOfStations(fromStationCode:String, toStationCode:String)
}

class RailsRouter: BaseRouter
{
    
    var endpoint: MetroRailsEndpoint
    init(endpoint: MetroRailsEndpoint)
    {
        self.endpoint = endpoint
    }
    
    override var method: Alamofire.HTTPMethod
    {
        switch endpoint
        {
            case .getRails:             return .get
            case .getStations:          return .get
            case .getPathOfStations:    return .get
        }
    }
    
    override var path: String
    {
        switch endpoint
        {
        case .getRails: return "/Rail.svc/json/jLines"
        case .getStations( _): return "/Rail.svc/json/jStations"
        case .getPathOfStations( _, _): return "/Rail.svc/json/jPath"
        }
    }
    
    override var parameters: APIParams
    {
        switch endpoint
        {
        case .getRails: return nil
        case .getStations(let lineCode):
            return ["LineCode": lineCode]
        case .getPathOfStations(let fromStationCode, let toStationCode):
            return ["FromStationCode": fromStationCode,
                    "ToStationCode"  : toStationCode]
        }
    }
}
