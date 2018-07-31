//
//  doctorAPI.swift
//  VivySearch
//
//  Created by Anuraag Shakya on 26.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import Foundation
import SwiftyJSON

class DoctorAPI {
    static let sharedInstance = DoctorAPI()
    
    // MARK: User credential constants
    
    let username = "ioschallenge@uvita.eu"
    let password = "shouldnotbetoohard"
    
    // MARK: Endpoint constants
    
    let authenticationEndpoint  = "https://api.uvita.eu/oauth/token"
    let searchEndpoint          = "https://api.uvita.eu/api/users/me/doctors"
    let pictureEndpoint         = "https://api.uvita.eu/api/users/me/files"
    
    // MARK: API methods
    
    func authenticate(onFailure: @escaping (ErrorResult) -> ()) {
        let url = URL(string: authenticationEndpoint)
        guard url != nil else {
            onFailure(ErrorResult.network(string: "Could not access URL"))
            return
        }
        var request = RequestFactory.request(method: .POST, url: url!)

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic aXBob25lOmlwaG9uZXdpbGxub3RiZXRoZXJlYW55bW9yZQ==", forHTTPHeaderField: "Authorization")
        
        let postString = "grant_type=password&username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        
        performNetworkTask(request: request, onFailure: onFailure)
    }
    
    func queryDoctorsUsing(text: String, onFailure: @escaping (ErrorResult) -> ()) {
        var request = RequestFactory.request(method: .GET, url: URL(string: searchEndpoint)!)
        let authToken = ""
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic \(authToken)", forHTTPHeaderField: "Authorization")
        
        let postString = "/text=\(text)"
        request.httpBody = postString.data(using: .utf8)
        
        performNetworkTask(request: request, onFailure: onFailure)
    }
    
    func performNetworkTask(request: URLRequest, onFailure: @escaping (ErrorResult) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for networking errors
            guard let _ = data, error == nil else {
                onFailure(ErrorResult.network(string: error!.localizedDescription))
                return
            }
            
            // Check for HTTP errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                onFailure(ErrorResult.network(string: "statusCode should be 200, but is \(httpStatus.statusCode)"))
                return
            }
        }
        task.resume()
    }
}
