//
//  ResponseHandler.swift
//  PHAB_Framework
//
//  Created by Pedro Bandeira on 09/03/19.
//  Copyright © 2019 Pedro Bandeira. All rights reserved.
//

import Foundation

typealias CompletionBlock = (_ responseData: [String: Any]?,_ errorMessage: String?) -> Void
typealias DictionaryData = [String : Any]
typealias HeadersDictionary = [String: String]

class ResponseHandler {
    
    static func handleResponseData(_ data: Data?,_ errorMsg: String?) -> ([String: Any]?, String?) {
        if data == nil { return (nil, errorMsg) }
        
        guard let _data = data else { return (nil, errorMsg) }
        
        guard let response = try! JSONSerialization.jsonObject(with: _data, options: []) as? [String: Any] else { return (nil, errorMsg) }
        
        return (response, nil)
    }
    
}
