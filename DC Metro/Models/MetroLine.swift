//
//  MetroLine.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 7/29/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

import Foundation
import ObjectMapper

class MetroLine: Mappable {
    var lineCode: String?
    var displayName: String?
    var startStationCode: String?
    var endStationCode: String?
    var internalDestination1:String?
    var internalDestination2:String?
    
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        lineCode                <- map["LineCode"]
        displayName             <- map["DisplayName"]
        startStationCode        <- map["StartStationCode"]
        endStationCode          <- map["EndStationCode"]
        internalDestination1    <- map["InternalDestination1"]
        internalDestination2    <- map["InternalDestination2"]
    }
}
