//
//  AutocompleteTableViewController.swift
//  Dogs
//
//  Created by Anuraag Shakya on 01.08.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit
import SwiftyJSON

class AutocompleteTableViewController: UITableViewController {
    var isFiltering = false
    var dogsBreedList = [String]()
    var filteredBreedList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsetsMake(5, 15, 5, 5)
        readBreedsFromFile()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredBreedList.count : dogsBreedList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel(frame: cell.frame)
        label.text = isFiltering ? filteredBreedList[indexPath.row] : dogsBreedList[indexPath.row]
        cell.addSubview(label)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var searchConroller = self.parent as? SearchController
        searchConroller?.searchBar.text = isFiltering ? filteredBreedList[indexPath.row] : dogsBreedList[indexPath.row]
        searchConroller?.searchBarSearchButtonClicked(searchConroller!.searchBar)
    }
    
    // MARK: Private helper functions
    
    private func readBreedsFromFile() {
        guard let breedFilePath = Bundle.main.path(forResource: "breeds", ofType: "json") else {
            fatalError("Could not find file containing list of breeds")
        }
        
        guard let data = try? String(contentsOfFile: breedFilePath) else {
            fatalError("Could not read file containing list of breeds")
        }
        
        let jsonData = JSON(parseJSON: data)
        for breed in jsonData["message"].dictionaryValue {
            let subBreeds = breed.value.arrayValue
            if subBreeds.isEmpty {
                dogsBreedList.append(breed.key.capitalizingFirstLetter())
            } else {
                dogsBreedList.append("\(breed.key.capitalizingFirstLetter()) - All")
                for subBreed in subBreeds {
                    dogsBreedList.append("\(breed.key.capitalizingFirstLetter()) - \(subBreed.stringValue.capitalizingFirstLetter())")
                }
            }
        }
        
        dogsBreedList.sort()
    }

}
