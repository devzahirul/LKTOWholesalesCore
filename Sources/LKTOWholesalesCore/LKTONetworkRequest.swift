//
//  File.swift
//  
//
//  Created by Islam Md. Zahirul on 3/11/22.
//

import Foundation

public class LKTONetworkRequest: NSObject {
    public var parent: LKTONetwork?
    public var endpoint: LKTOAPIEndpoint
    public var forceRefresh = false
    private var task: URLSessionTask?
    init(_ endpoint: LKTOAPIEndpoint, parent: LKTONetwork) {
        self.parent = parent
        self.endpoint = endpoint
    }
    
    public func resume(completion: @escaping(Result<DataSerializer, LKTOError>) -> Void) {
        guard  task == nil || forceRefresh else {
            task?.resume()
            return
        }
       task = parent?.requestHandler.handle(request: endpoint.createURLRequest(for: parent?.environment ?? .test)!, completion: { result in
            switch result {
            case .success(let data): do {
                print("Success \(String(data: data, encoding: .utf8))")
                completion(.success(DataSerializer(data: data)))
            }
            case .failure(let lktError): do {
                completion(.failure(lktError))
            }
            }
        })
        task?.resume()
    }
    func cancel() {}
    func pause() {}
    func loadMore() {}
    func change(endpoint: LKTOAPIEndpoint) {}
    
}
