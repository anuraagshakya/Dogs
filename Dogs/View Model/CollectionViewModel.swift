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
    var dataSource: CollectionViewDataSource
    var dogBreeds = [String:[String]]()
    
    init(dataSouce: CollectionViewDataSource) {
        self.dataSource = dataSouce
        self.readBreedsFromFile()
    }
    
    // MARK: Endpoint constants
    
    let endpoint = "https://dog.ceo/api/breed"
    
    // MARK: API methods
    func fetchImagesOf(breed: String, onFailure: @escaping (ErrorResult?) -> () = {_ in }) {
        // Check if user requested search is for a valid dog breed
        guard dogBreeds[breed.lowercased()] != nil else {
            onFailure(ErrorResult.other(string: "\"\(breed)\" is not a valid dog breed"))
            return
        }
        
        let trailString = "/\(breed.lowercased())/images"
        guard let endpointUrl = URL(string: endpoint + trailString) else {
            onFailure(ErrorResult.network(string: "Invalid endpoint URL"))
            return
        }
        var request = RequestFactory.request(method: .GET, url: endpointUrl)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for networking errors
            guard let data = data, error == nil else {
                onFailure(ErrorResult.network(string: error!.localizedDescription))
                return
            }
            
            // Check for HTTP errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                onFailure(ErrorResult.network(string: "statusCode should be 200, but is \(httpStatus.statusCode)"))
                return
            }
            
            // Check JSON response errors
            let responseString = String(data: data, encoding: .utf8) ?? ""
            let json = JSON(parseJSON: responseString)
            guard json["status"].stringValue == "success" else {
                onFailure(ErrorResult.parser(string: "JSON status not 'success'"))
                return
            }
            
            // Parse result
            self.parseJSON(json: json)
        }
        task.resume()
    }
    
    // MARK: Helper functions
    
    private func readBreedsFromFile() {
        guard let breedFilePath = Bundle.main.path(forResource: "breeds", ofType: "json") else {
            fatalError("Could not find file containing list of breeds")
        }
        
        guard let data = try? String(contentsOfFile: breedFilePath) else {
            fatalError("Could not read file containing list of breeds")
        }
        
        let jsonData = JSON(parseJSON: data)
        for dataPoint in jsonData["message"].dictionaryValue {
            var stringArray = [String]()
            for value in dataPoint.value.arrayValue {
                stringArray.append(value.stringValue)
            }
            dogBreeds[dataPoint.key] = stringArray
        }
    }
    
    private func parseJSON(json: JSON) {
        var data = [DogImage]()
        for dataPoint in json["message"].arrayValue {
            let urlString = dataPoint.stringValue
            let dogImage = DogImage(urlString: urlString)
            data.append(dogImage)
        }
        dataSource.data = data
    }

}
