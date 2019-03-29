//
//  NetworkInterface.swift
//  PHAB_Framework
//
//  Created by Pedro Bandeira on 06/03/19.
//  Copyright © 2019 Pedro Bandeira. All rights reserved.
//

import Foundation

protocol Networkable: class {
    func create<T: Codable>(_ object: T, endpoint: String, completion: @escaping CompletionBlock)
    func get(endpoint: String, completion: @escaping CompletionBlock)
    func update<T: Codable>(_ object: T, endpoint: String, completion: @escaping CompletionBlock)
    func delete<T: Codable>(_ object: T, endpoint: String, completion: @escaping CompletionBlock)
}

extension Networkable {
    
    func create<T: Codable>(_ object: T, endpoint: String, headers: HeadersDictionary? = nil, completion: @escaping CompletionBlock) {
        let dataObject = try! JSONEncoder().encode(object)
        guard let parameters = try! JSONSerialization.jsonObject(with: dataObject, options: .allowFragments) as? [String: Any] else { return }
        
        NetworkLayer.request(method: .post, parameters: parameters, headers: headers, endpoint: endpoint) { (data, errorMsg) in
            let handleResponse = ResponseHandler.handleResponseData(data, errorMsg)
            completion(handleResponse.0, handleResponse.1)
        }
    }
    
    func get(endpoint: String, headers: HeadersDictionary? = nil, completion: @escaping CompletionBlock) {
        NetworkLayer.request(method: .get, headers: headers, endpoint: endpoint) { (data, errorMsg) in
            let handleResponse = ResponseHandler.handleResponseData(data, errorMsg)
            completion(handleResponse.0, handleResponse.1)
        }
    }
    
    func update<T: Codable>(_ object: T, endpoint: String, headers: HeadersDictionary? = nil, completion: @escaping CompletionBlock) {
        let dataObject = try! JSONEncoder().encode(object)
        guard let parameters = try! JSONSerialization.jsonObject(with: dataObject, options: .allowFragments) as? [String: Any] else { return }
        
        NetworkLayer.request(method: .patch, parameters: parameters, headers: headers, endpoint: endpoint) { (data, errorMsg) in
            let handleResponse = ResponseHandler.handleResponseData(data, errorMsg)
            completion(handleResponse.0, handleResponse.1)
        }
    }
    
    func delete<T: Codable>(_ object: T, endpoint: String, headers: HeadersDictionary? = nil, completion: @escaping CompletionBlock) {
        let dataObject = try! JSONEncoder().encode(object)
        guard let parameters = try! JSONSerialization.jsonObject(with: dataObject, options: .allowFragments) as? [String: Any] else { return }
        
        NetworkLayer.request(method: .delete, parameters: parameters, headers: headers, endpoint: endpoint) { (data, errorMsg) in
            let handleResponse = ResponseHandler.handleResponseData(data, errorMsg)
            completion(handleResponse.0, handleResponse.1)
        }
    }
    
    private func handleResponseData(_ data: Data?,_ errorMsg: String?) -> ([String: Any]?, String?) {
        if data == nil { return (nil, errorMsg) }
        
        guard let _data = data else { return (nil, errorMsg) }
        
        guard let response = try! JSONSerialization.jsonObject(with: _data, options: []) as? [String: Any] else { return (nil, errorMsg) }
        
        return (response, nil)
    }
}
