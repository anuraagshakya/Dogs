//
//  CollectionViewModel.swift
//  Dogs
//
//  Created by Anuraag Shakya on 31.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit
import SwiftyJSON

class CollectionViewModel {
    // MARK: Endpoint constants
    
    let endpoint = "https://dog.ceo/api/breed"
    
    // MARK: API methods
    func fetchImagesOf(breed: String, subBreed: String?, completion: @escaping (DogSearchResult?, ErrorResult?) -> () = { _, _  in }) {
        
        // Append breed and sub-breed to API endpoint
        var trailString: String
        if let subBreed = subBreed {
            trailString = "/\(breed.lowercased())/\(subBreed.lowercased())/images"
        } else {
            trailString = "/\(breed.lowercased())/images"
        }
        guard let endpointUrl = URL(string: endpoint + trailString) else {
            let err = ErrorResult.network(string: "Invalid endpoint URL")
            completion(nil, err)
            return
        }
        
        // Prepare URLRequest
        var request = RequestFactory.request(method: .GET, url: endpointUrl)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for networking errors
            guard let data = data, error == nil else {
                let err = ErrorResult.network(string: error!.localizedDescription)
                completion(nil, err)
                return
            }
            
            // Check for HTTP errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                let err = ErrorResult.network(string: "statusCode should be 200, but is \(httpStatus.statusCode)")
                completion(nil, err)
                return
            }
            
            // Check JSON response errors
            let responseString = String(data: data, encoding: .utf8) ?? ""
            let json = JSON(parseJSON: responseString)
            guard json["status"].stringValue == "success" else {
                let err = ErrorResult.parser(string: "JSON status not 'success'")
                completion(nil, err)
                return
            }
            
            // Parse result
            let results = DogSearchResult(breed: breed,
                                          subBreed: subBreed,
                                          images: self.parseJSON(json: json))
            completion(results, nil)
        }
        task.resume()
    }
    
    // MARK: Helper functions
    
    private func parseJSON(json: JSON) -> [String] {
        var data = [String]()
        for dataPoint in json["message"].arrayValue {
            let urlString = dataPoint.stringValue
            data.append(urlString)
        }
        return data
    }

}
