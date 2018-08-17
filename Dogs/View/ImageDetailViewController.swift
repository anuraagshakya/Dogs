//
//  ImageDetailViewController.swift
//  Dogs
//
//  Created by Anuraag Shakya on 17.08.18.
//  Copyright © 2018 Bhunte. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    var image: UIImage?
    
    init(image: UIImage?) {
        self.image = image

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        
        // Set title display mode to small and turn on hiding of nav bar on tap
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    private func setupImageView() {
        let imageView = UIImageView(image: self.image)
        view.addSubview(imageView)
        
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
