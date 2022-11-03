//
//  File.swift
//  
//
//  Created by Islam Md. Zahirul on 3/11/22.
//

import Foundation

public enum LKTOAPIMethod: String {
    case POST
    case GET
}


extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

public struct LKTOAPIEndpoint {
    public let path: String
    public var method: LKTOAPIMethod = .GET
    public var params: [String: String]? = nil
    
    public init(path: String, method: LKTOAPIMethod = .GET, params: [String: String]? = nil) {
        self.path = path
        self.method = method
        self.params = params
    }
    
    public var urlComponents = URLComponents()
    
    public mutating func createURLRequest(for environment: NetworkEnvironment) -> URLRequest? {
        let baseURL = URL(string: environment.baseURL)
        
        
       
        urlComponents.scheme = baseURL?.scheme ?? "https"
        urlComponents.host = baseURL?.host ?? ""
        urlComponents.path = path
        
        if let queryParams = params {
            urlComponents.setQueryItems(with: queryParams)
        }
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
}
