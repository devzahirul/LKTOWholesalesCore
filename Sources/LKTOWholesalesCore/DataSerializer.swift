//
//  File.swift
//  
//
//  Created by Islam Md. Zahirul on 3/11/22.
//

import Foundation

public struct DataSerializer {
    public let data: Data
    public var decoder =  JSONDecoder()
    
    public func decode<T: Decodable>() -> T? {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {}
        return nil
    }
}
