//
//  ErrorResult.swift
//  VivySearch
//
//  Created by Anuraag Shakya on 27.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case other(string: String)
    
    func description() -> String {
        switch self {
        case .network(let string):
            return "Network Error: \(string)"
        case .parser(let string):
            return "Parser Error: \(string)"
        case .other(let string):
            return "Error: \(string)"
        }
    }
}
