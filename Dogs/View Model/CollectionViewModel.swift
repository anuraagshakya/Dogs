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
    
    init(dataSouce: CollectionViewDataSource) {
        self.dataSource = dataSouce
    }
    
    // MARK: Endpoint constants
    
    let endpoint          = "https://dog.ceo/api/breed"
    
    // MARK: API methods
    func fetchImagesOf(breed: String, onFailure: @escaping (ErrorResult?) -> () = {_ in }) {
        let trailString = "/\(breed)/images"
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
    
    private func parseJSON(json: JSON) {
        var data = [DogImage]()
        for dataPoint in json["message"].arrayValue {
            let urlString = dataPoint.stringValue
            let dogImage = DogImage(urlString: urlString)
            data.append(dogImage)
        }
        dataSource.data = data
    }
    
//    func sampleImagesFill() {
//        for i in 0...9 {
//            dataSource.data.append(UIImage(named: String(i))!)
//        }
//    }
}
