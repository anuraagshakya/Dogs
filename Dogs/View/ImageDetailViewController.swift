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
    var imageView: UIImageView!
    
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
        setupNavigationBar()
        addPinchGestureToImageView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Turn off nav bar hiding before view dissappears
        navigationController?.hidesBarsOnTap = false
    }
    
    // MARK: - Private helper functions
    
    @objc private func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let currentScale = imageView.frame.size.width / imageView.bounds.size.width
        let newScale = sender.scale * currentScale
        let transform = CGAffineTransform(scaleX: newScale, y: newScale)
        
        switch sender.state {
        case .began, .changed:
            imageView.transform = transform
            sender.scale = 1
        default:
            break
        }
    }
    
    private func setupImageView() {
        imageView = UIImageView(image: self.image)
        view.addSubview(imageView)
        
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        // Set title display mode to small and turn on hiding of nav bar on tap
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.hidesBarsOnTap = true
    }
    
    private func addPinchGestureToImageView() {
        // Add pinch gesture recogniser to imageView
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(sender:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGesture)
    }

}
