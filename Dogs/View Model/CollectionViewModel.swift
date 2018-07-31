//
//  CollectionViewModel.swift
//  Dogs
//
//  Created by Anuraag Shakya on 31.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

class CollectionViewModel {
    var dataSource: CollectionViewDataSource
    
    init(dataSouce: CollectionViewDataSource) {
        self.dataSource = dataSouce
    }
    
    func sampleImagesFill() {
        for i in 0...9 {
            dataSource.data.append(UIImage(named: String(i))!)
        }
    }
}
