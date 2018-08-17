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

        let imageView = UIImageView(frame: view.frame)
        imageView.image = self.image
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        navigationItem.largeTitleDisplayMode = .never
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}
