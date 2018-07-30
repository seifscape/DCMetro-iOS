//
//  APIManager.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 7/29/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

import Foundation
import KeychainAccess
import Alamofire
import OHHTTPStubs

// Singleton of CaptiveReach API Manager
// Possibly research best pratices for Swift 3/4 Singelton via Google (Swift Singleton)

final class APIManager {
    let keychain = Keychain(service: "com.districtmetaworks.dcmetro")
    var baseURL = K.APIEndpoint.baseURL
    
    static let sharedInstance = APIManager()
    
    static let sessionManager: SessionManager = {
        let sessionManager = Alamofire.SessionManager.default
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        sessionManager.adapter = CustomRequestAdapter()
        return sessionManager
    }()
    
    // request adpater to add default http header parameter
    private class CustomRequestAdapter: RequestAdapter {
        public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            var urlRequest = urlRequest
            urlRequest.setValue(K.APIParameterKey.apiKey, forHTTPHeaderField: "api_key")
            return urlRequest
        }
    }
    
    
    internal init() {}
    
    static func getSessionManager() -> SessionManager {
        return sessionManager
    }
    
    static func getInstance() -> APIManager {
        OHHTTPStubs.setEnabled(true, for: sessionManager.session.configuration)
        return sharedInstance
    }
    
    
    
    /*
     let manager: SessionManager?
     init() {
     weak var mySelf = sessionManager
     let configuration = URLSessionConfiguration.default
     manager = Alamofire.SessionManager(configuration: configuration)
     
     OHHTTPStubs.setEnabled(true, for: configuration)
     OHHTTPStubs.setEnabled(true, for: SessionManager.shared.sessionManager.session.configuration)
     OHHTTPStubs.setEnabled(true, for: SessionManager.default.session.configuration)
     
     
     }
     */
}
