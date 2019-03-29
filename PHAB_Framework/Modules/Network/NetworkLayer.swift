//
//  NetworkLayer.swift
//  PHAB_Framework
//
//  Created by Pedro Bandeira on 06/03/19.
//  Copyright © 2019 Pedro Bandeira. All rights reserved.
//

import Foundation
import Alamofire

class NetworkLayer {
    
    static func request(method: HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, endpoint: String ,completionHandler: @escaping (_ response: Data?, _ error: String? )->Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        AF.request(endpoint, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers as? HTTPHeaders).responseJSON { (response) in
            
            if response.request?.httpBody != nil {
                let jsonParams = try? JSONSerialization.jsonObject(with: response.request!.httpBody!, options: [])
                if let j = jsonParams { print("request body post \(j)") }
            }
            
            debugPrint(response)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success(_):
                completionHandler(response.data, nil)
                break
            case .failure(_):
                completionHandler(nil, response.result.error.debugDescription)
                break
            }
        }
    }
}
