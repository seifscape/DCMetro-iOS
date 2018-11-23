//
//  MetroStation.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 8/19/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

// metrohero api
// mattress cache sync magicalrecord sugarrecord realm subclass nsmanagedobject pfobject
//skeleton upgrade tableview loading empty tableview relaod (swift) animation loading tableview enum tableview amex capital one
// stateful tableview

import Foundation
import ObjectMapper

class MetroStation: Mappable {
    var isMultiPlatform:Bool?
    var address:Address?
    var coordinates:AnyObject?
    var platforms:Array<Platform>?
    var stationTogether:String?
    var stationCode:String?
    var name:String?
    var code:String?
    var lineCode:String
    var lineCode1:String
    var stationName:String
    var seqNumber:Int
    var distanceToPrev:Int
    
    
    required init?(map: Map) {
        lineCode        = String()
        lineCode1       = String()
        stationName     = String()
        seqNumber       = 0
        distanceToPrev  = 0
    }
    
    // Mappable
    func mapping(map: Map) {
        code            <- map["Code"]
        name            <- map["Name"]
        stationTogether <- map["StationTogether1"]
        lineCode        <- map["LineCode"]
        lineCode1       <- map["LineCode1"]
        stationName     <- map["StationName"]
        stationCode     <- map["StationCode"]
        seqNumber       <- map["SeqNum"]
        distanceToPrev  <- map["DistanceToPrev"]

    }
}
