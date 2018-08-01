//
//  ViewController.swift
//  Dogs
//
//  Created by Anuraag Shakya on 31.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
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
    }
    
    func displayError(_ error: ErrorResult) {
        let ac = UIAlertController(title: "An Error Occurred", message: error.description(), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
}

extension CollectionViewController: SearchActionDelegate {
    func searchBarDidRequestSearchFor(string: String) {
        viewModel.fetchImagesOf(breed: string) { [unowned self] (error) in
            if let error = error {
                self.displayError(error)
            }
        }
    }
}

