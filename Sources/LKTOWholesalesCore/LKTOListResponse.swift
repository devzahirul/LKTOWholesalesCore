//
//  File.swift
//  
//
//  Created by Islam Md. Zahirul on 3/11/22.
//

import Foundation

public struct LKTOListResponse<model: Decodable>: Decodable {
    public let data: [model]
}

public struct LKTODictionaryResponse<model: Decodable>: Decodable {
    public let data: model
}
