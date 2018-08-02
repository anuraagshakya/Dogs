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
    var searchController: SearchController!
    var autocompleteView: AutocompleteTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item title
        navigationItem.title = "Dogs"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup search controller
        autocompleteView = AutocompleteTableViewController(style: .plain)
        
        searchController = SearchController(searchResultsController: autocompleteView)
        searchController.searchActionDelegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Setup datasource
        collectionView?.dataSource = dataSource
        dataSource.onDataUpdated = { [unowned self] in
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        
        // Setup view model
        viewModel = CollectionViewModel()
    }
    
    private func displayError(_ error: ErrorResult) {
        let ac = UIAlertController(title: "An Error Occurred", message: error.description(), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
}

extension CollectionViewController: SearchActionDelegate {
    func searchBarDidRequestSearchFor(string: String) {
        let searchParts = string.split(separator: "-")
        var breed: String
        var subBreed: String?
        breed = String(searchParts[0]).trimmingCharacters(in: .whitespacesAndNewlines)
        if searchParts.count == 2 {
            subBreed = String(searchParts[1]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        viewModel.fetchImagesOf(breed: breed, subBreed: subBreed) { [unowned self] (results, error) in
            guard error == nil else {
                self.displayError(error!)
                return
            }
            
            guard let results = results else {
                return
            }
            
            self.dataSource.data = results.images
        }
    }
}

