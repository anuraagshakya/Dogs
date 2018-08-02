//
//  SearchBar.swift
//  VivySearch
//
//  Created by Anuraag Shakya on 27.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

@objc protocol SearchActionDelegate {
    func searchBarDidRequestSearchFor(string: String)
}

class SearchController: UISearchController {
    var searchActionDelegate: SearchActionDelegate?
    var autocompleteView: AutocompleteTableViewController!
    var isFitering = false
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        
        self.searchBar.delegate = self
        self.searchResultsUpdater = self
        self.autocompleteView = searchResultsController! as! AutocompleteTableViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        autocompleteView.isFiltering = isActive && !searchBarIsEmpty()
        autocompleteView.filteredBreedList = autocompleteView.dogsBreedList.filter({( breed : String) -> Bool in
            return breed.lowercased().contains(searchText.lowercased())
        })
        
        autocompleteView.tableView.reloadData()
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        autocompleteView.view.isHidden = false
        filterContentForSearchText(searchBar.text!)
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var searchText = searchBar.text ?? ""
        if !autocompleteView.dogsBreedList.contains(searchText) {
            searchText = autocompleteView.filteredBreedList[0]
        }
        self.dismiss(animated: true) { [unowned self] in
        self.searchBar.text = searchText
        self.searchActionDelegate?.searchBarDidRequestSearchFor(string: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
