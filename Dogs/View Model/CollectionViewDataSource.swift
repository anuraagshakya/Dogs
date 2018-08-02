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
            onDataUpdated()
        }
    }
    
    var onDataUpdated: () -> () = {}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.urlString = data[indexPath.row]
        return cell
    }
    
}
