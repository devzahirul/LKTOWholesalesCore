//
//  File.swift
//  
//
//  Created by Islam Md. Zahirul on 31/10/22.
//


import Foundation

public protocol Platform {
    static func getShared() -> Platform
    func getNetwork() -> LKTONetwork
}




public class LKTOWholesalesPlatform: Platform {
    public let baseURL = ""
    public static let shared = LKTOWholesalesPlatform()
    public let network: LKTONetwork
    
    
    public static func getShared() -> Platform {
        return shared
    }
    
    public func getNetwork() -> LKTONetwork {
        return network
    }
    
    init() {
        network = LKTONetwork(.production)
    }
}

























