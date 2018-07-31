//
//  RequestFactory.swift
//  VivySearch
//
//  Created by Anuraag Shakya on 30.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import Foundation

class RequestFactory {
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }

    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
