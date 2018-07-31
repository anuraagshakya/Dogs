//
//  CollectionViewCell.swift
//  Dogs
//
//  Created by Anuraag Shakya on 31.07.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var urlString: String! {
        didSet {
            self.imageView.image = nil
            fetchImageFromUrl(self.urlString)
        }
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
    }
    
    func fetchImageFromUrl(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
    
}
