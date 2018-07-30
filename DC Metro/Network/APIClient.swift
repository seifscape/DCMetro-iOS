//
//  APIClient.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 7/29/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

import Alamofire

class APIClient {
    /*
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter,
                                                    decoder: JSONDecoder = JSONDecoder(),
                                                    completion:@escaping (Result<T>)->Void) -> DataRequest {
        
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["Content-Type"] = "application/json"
        defaultHeaders["Accept"] = "application/json"
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        
        return manager.request(route).responseJSONDecodable (decoder: decoder){ (response: DataResponse<T>) in
            completion(response.result)
        }
    }
 */
}
