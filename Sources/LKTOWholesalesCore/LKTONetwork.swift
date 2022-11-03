//
//  File.swift
//  
//
//  Created by Islam Md. Zahirul on 3/11/22.
//

import Foundation

public class LKTONetwork {
    public var environment: NetworkEnvironment
    public var requestHandler: LKTONetworkRequestable
    init( _ environment: NetworkEnvironment, requestHandler: LKTONetworkRequestable = URLSession.shared) {
        self.environment = environment
        self.requestHandler = requestHandler
    }
    
    public func createRequest(for endPoint: LKTOAPIEndpoint) -> LKTONetworkRequest {
        return LKTONetworkRequest(endPoint, parent: self)
    }
}
