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
    var data = [DogImage]() {
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
        cell.urlString = data[indexPath.row].urlString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SearchViewHeader", for: indexPath) as! SearchCollectionReusableView
                        
            return headerView
        }
        
        return UICollectionReusableView()
    }
}
