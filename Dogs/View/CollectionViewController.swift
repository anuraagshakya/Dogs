//
//  ViewController.swift
//  Dogs
//
//  Created by Anuraag Shakya on 31.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    // dataSource: The data source this collection view
    // viewModel: The view model which handles app data
    // searchController: UISearchController subclass that is embedded into the
    //  navigation bar
    // autocompleteView: UITableView subclass to show search recommendations
    let dataSource = CollectionViewDataSource()
    var viewModel: CollectionViewModel!
    var searchController: SearchController!
    var autocompleteView: AutocompleteTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item title
        navigationItem.title = "Dogs"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup search controller with autocomplete view
        setupSearchControllerAndAutocompleteView()
        
        // Setup datasource. Important part is to reload the collection view
        //  data using the dataSource's onDataUpdated closure
        collectionView?.dataSource = dataSource
        dataSource.onDataUpdated = { [unowned self] in
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        
        // Setup view model
        viewModel = CollectionViewModel()
    }
    
    // MARK: Private helper functions
    
    private func setupSearchControllerAndAutocompleteView() {
        autocompleteView = AutocompleteTableViewController(style: .plain)
        searchController = SearchController(searchResultsController: autocompleteView)
        searchController.searchActionDelegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func displayError(_ error: ErrorResult) {
        let ac = UIAlertController(title: "An Error Occurred", message: error.description(), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
}

// MARK: SearchActionDelegate methods extension

extension CollectionViewController: SearchActionDelegate {
    func searchControllerDidRequestSearchFor(string: String) {
        // Method called when searchController requests a search
        
        // Separate search strig into breed and sub-breed parts. Then call the
        //  view model's fetchImagesOf method using the breed and sub-breed.
        let searchParts = string.split(separator: "-")
        var breed: String
        var subBreed: String?
        breed = String(searchParts[0]).trimmingCharacters(in: .whitespacesAndNewlines)
        if searchParts.count == 2 {
            subBreed = String(searchParts[1]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        // Sub-breed "All" is used to get all sub-breeds for a breed therefore
        //  the specific sub-breed parameter should be set to nil
        if subBreed == "All" {
            subBreed = nil
        }
        viewModel.fetchImagesOf(breed: breed, subBreed: subBreed) { [unowned self] (results, error) in
            // Check for errors while fetching images
            guard error == nil else {
                self.displayError(error!)
                return
            }
            
            // Set the results as the data source for this collection view. We
            //  can force unwrap because we know result is not nil if there is
            //  no error
            self.dataSource.data = results!.images
        }
    }
}

