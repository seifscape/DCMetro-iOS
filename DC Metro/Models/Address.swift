//
//  Address.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 8/20/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

import Foundation
import ObjectMapper

class Address: Mappable {
    var street: String
    var city: String
    var state: String
    var zip: String
    
    
    required init?(map: Map) {
        street  = String()
        city    = String()
        state   = String()
        zip     = String()
    }
    
    // Mappable
    func mapping(map: Map) {
        street      <- map["LineCode"]
        city        <- map["DisplayName"]
        state       <- map["StartStationCode"]
        zip         <- map["EndStationCode"]
    }
}
