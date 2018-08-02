//
//  CollectionViewDataSource.swift
//  Dogs
//
//  Created by Anuraag Shakya on 31.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit
import Foundation

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var data = [String]() {
        didSet {
            // Call on data updated closure every time data is updated
            onDataUpdated()
        }
    }
    
    var onDataUpdated: () -> () = {}
    
    
    // MARK: UICollectionViewDataSource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 10
        cell.urlString = data[indexPath.row]
        return cell
    }
    
}
