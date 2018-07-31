//
//  ViewController.swift
//  Dogs
//
//  Created by Anuraag Shakya on 31.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let dataSource = CollectionViewDataSource()
    var viewModel: CollectionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item title
        navigationItem.title = "Dogs"
        
        // Setup datasource
        collectionView?.dataSource = dataSource
        dataSource.onDataUpdated = { [unowned self] in
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        
        // Setup view model
        viewModel = CollectionViewModel(dataSouce: dataSource)
        
        // Load data
//        viewModel.sampleImagesFill()
        viewModel.fetchImagesOf(breed: "hound") { (error) in
            if let error = error {
                print(error.description())
            }
        }
    }

}

