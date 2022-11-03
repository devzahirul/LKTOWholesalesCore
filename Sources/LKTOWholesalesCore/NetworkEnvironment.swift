//
//  File.swift
//  
//
//  Created by Islam Md. Zahirul on 3/11/22.
//

import Foundation

public struct NetworkEnvironment {
    public let baseURL: String
}

extension NetworkEnvironment {
    public static let test = NetworkEnvironment(baseURL: "http://localhost.com")
    public static let production =   NetworkEnvironment(baseURL: "https://davidani.com")
}


