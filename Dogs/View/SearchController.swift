//
//  SearchBar.swift
//  VivySearch
//
//  Created by Anuraag Shakya on 27.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

// MARK: SearchActionDelegate protocol used to notify search requests
protocol SearchActionDelegate {
    func searchControllerDidRequestSearchFor(string: String)
}

class SearchController: UISearchController {
    var searchActionDelegate: SearchActionDelegate?
    var autocompleteView: AutocompleteTableViewController?
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        
        // Set delegates to self
        self.searchBar.delegate = self
        self.searchResultsUpdater = self
        
        // Cast and save pointer searchResultsController as AutocompleteTableViewController
        guard let autoCompleteView = searchResultsController as? AutocompleteTableViewController else {
            assertionFailure("Could not cas to AutoCompleteTableViewController or does not exist: \(String(describing: searchResultsController))")
            return
        }
        self.autocompleteView = autoCompleteView
    }
    
    // Overrides required by UIKit when overriding any init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        // Filters results based on searchText and adds them to
        //  filteredBreedList in our autocompleteView. Also sets isFiltering
        //  boolean which is used to decide whether to display entire list or
        //  filtered list.
        guard let safeAutocompleteView = autocompleteView else {
            assertionFailure("Autocomplete view does not exist")
            return
        }
        
        safeAutocompleteView.isFiltering = isActive && !searchBarIsEmpty()
        safeAutocompleteView.filteredBreedList =
            safeAutocompleteView.dogsBreedList.filter({( breed : String) -> Bool in
            return breed.lowercased().contains(searchText.lowercased())
        })
        
        // Reload the autocompleteViews table to show filtered content.
        safeAutocompleteView.tableView.reloadData()
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let safeAutocompleteView = autocompleteView else {
            assertionFailure("Autocomplete view does not exist")
            return
        }
        
        // Show autocompleteView whenever searchController is active. Call our
        //  filterContentForSearchText method.
        safeAutocompleteView.view.isHidden = false
        filterContentForSearchText(searchBar.text!)
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let safeAutocompleteView = autocompleteView else {
            assertionFailure("Autocomplete view does not exist")
            return
        }
        
        // Unwrap search text. Check if search text is valid based on list of
        //  valid search strings, if not then search for first result in
        //  in filteredBreedList. This way we make sure to not make an invalid
        //  API call.
        var searchText = searchBar.text ?? ""
        if !safeAutocompleteView.dogsBreedList.contains(searchText) {
            guard !safeAutocompleteView.filteredBreedList.isEmpty else {
                return
            }
            searchText = safeAutocompleteView.filteredBreedList[0]
        }
        
        // Set the searchBar text to represent what we are actually searching
        //  for. Call searchControllerDidRequestSearchFor method on the delegate
        self.dismiss(animated: true) { [unowned self] in
            self.searchBar.text = searchText
            self.searchActionDelegate?.searchControllerDidRequestSearchFor(string: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // On cancellation, clear search bar and resignFirstResponder
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
