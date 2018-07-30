//
//  RailsServices.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 7/29/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit
import KeychainAccess
import ObjectMapper
import AlamofireObjectMapper


// PromiseKit loading activity indicator
class RailsServices {
    
    var keychain = Keychain(service: "com.parallel6.captivereachsdk-swift")
    let manager = SessionManager()
    let customSessionManager = APIManager.sessionManager
    private let sharedInstance = APIManager.sharedInstance
    
    
    func retriveLines()-> Promise <[MetroLine]> {
        return Promise { seal in
            let router = RailsRouter(endpoint: .getRails)
            customSessionManager.request(router)
                .responseJSON {
                    response in
                    guard response.result.error == nil
                        else {
                            print("error")
                            print(response.result.error!)
                            return
                    }
                    switch response.result {
                    case .success(let jsonResponse):
                        print(jsonResponse)
                        if response.response?.statusCode == 200 {
                            if let data = jsonResponse as? Dictionary<String, AnyObject> {
                                if let rawJson = data["Lines"] as? [[String: AnyObject]] {
                                    let metroLines : Array<MetroLine> = Mapper<MetroLine>().mapArray(JSONArray: rawJson)
                                        seal.fulfill(metroLines)
                                }
                            }
                        }
                    case .failure(let error):
                        print(error)
                        seal.reject(NSError(domain: "error retriving user", code:404, userInfo: nil))
                    }
            }
        }
    }
}
