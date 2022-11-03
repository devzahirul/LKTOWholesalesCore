//
//  File.swift
//  
//
//  Created by Islam Md. Zahirul on 3/11/22.
//

import Foundation

public protocol LKTONetworkRequestable: AnyObject {
    func handle(request: URLRequest, completion: @escaping(Result<Data, LKTOError>) -> Void) -> URLSessionTask
}


extension URLSession: LKTONetworkRequestable {
    public func handle(request: URLRequest, completion: @escaping(Result<Data, LKTOError>) -> Void) -> URLSessionTask {
        
        print(request.url?.absoluteString)
        
        return self.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.requestError(error)))
                return
            }
            //print("Success \(String(data: data, encoding: .utf8))")
            completion(.success(data))
        }
    }
}
