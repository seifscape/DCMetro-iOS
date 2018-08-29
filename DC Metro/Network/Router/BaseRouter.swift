//
//  BaseRouter.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 7/29/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

import Foundation
import Alamofire
//import Reachability

public typealias JSONDictionary = [String: Any]?
typealias APIParams = [String : Any]?

protocol APIConfiguration {
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var parameters: APIParams { get }
    var baseUrl: String { get }
}

class BaseRouter : URLRequestConvertible, APIConfiguration {
    
    
    enum HTTPStatusCodes : Int {
        case created = 201
        case ok = 200
        case badRequest = 404
        case serverError = 500
    }
    
    init() {}
    
    func getHTTPStatusCode() -> HTTPStatusCodes {
        return .created
    }
    
    var method: Alamofire.HTTPMethod {
        fatalError("[BaseRouter - \(#function)] Must be overridden in subclass")
    }
    
    
    var path: String {
        fatalError("[BaseRouter - \(#function))] Must be overridden in subclass")
    }
    
    var parameters: APIParams { //Alamofire.Parameters {
        fatalError("[BaseRouter - \(#function))] Must be overridden in subclass")
    }
    
    
    var baseUrl: String {
        var config: NSDictionary?
        if let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)
        }
        var baseUrl = "";
        if let config = config {
            baseUrl = config["DRIVR_API_BASE_URL"] as! String
        }
        return baseUrl
    }
    
    func asURLRequest() throws -> URLRequest {
        // let sharedInstance = CaptiveReachAPIManager.sharedInstance
        //let baseURL = NSURL(string: baseUrl)
        //let baseURL = NSURL(string: Router.baseURLString!)
        let baseURL = URL(string: APIManager.getInstance().baseURL)
        //let url = URL(string: sharedInstance.baseURL) ?? URL(string: "https://api.localhost.com")
        var urlRequest = URLRequest(url: (baseURL?.appendingPathComponent(path))!)
        urlRequest.httpMethod = method.rawValue
        if let token = APIManager.getInstance().keychain["oauthtoken"] {
            urlRequest.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        }
        
        if self.method == Alamofire.HTTPMethod.post {
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: self.parameters)
        } else if self.method == Alamofire.HTTPMethod.put {
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: self.parameters)
        } else {
           return try Alamofire.URLEncoding.queryString.encode(urlRequest, with: self.parameters)
            //return urlRequest
        }
    }
}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

extension String {
    // https://useyourloaf.com/blog/how-to-percent-encode-a-url-string/
    // https://stackoverflow.com/a/45813868

    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
//        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) //https://stackoverflow.com/a/44643893
    }
}
