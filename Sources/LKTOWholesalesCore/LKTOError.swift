//
//  File.swift
//  
//
//  Created by Islam Md. Zahirul on 3/11/22.
//

import Foundation

public enum LKTOError: Error {
    case dataNilError
    case requestError(Error?)
    case dataParseError(message: String)
}
