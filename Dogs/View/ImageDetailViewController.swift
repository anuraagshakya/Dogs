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
        
        setupNavigationBar()
        setupImageView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Turn off nav bar hiding before view dissappears
        navigationController?.hidesBarsOnTap = false
    }
    
    // MARK: - Pinch to zoom behavior handler
    
    @objc private func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        let imageView = sender.view!
        
        var newScale = sender.scale * currentScale(of: imageView)
        newScale.limitToInclusiveRange(from: 0.8, to: 6.0)
        
        
        switch sender.state {
            
        case .began, .changed:
            scaleView(imageView, to: newScale)
            sender.scale = 1.0
            
        case .ended:
            animatedTransformationToIdentityIfRequired(on: imageView)
            sender.scale = 1.0
            
        default:
            break
        }
    }
    
    func currentScale(of view: UIView) -> CGFloat {
        return view.frame.size.width / view.bounds.size.width
    }
    
    func scaleView(_ view: UIView, to scale: CGFloat) {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        view.transform = transform
    }
    
    func animatedTransformationToIdentityIfRequired(on view: UIView) {
        if currentScale(of: view) < 1.0 {
            UIView.animate(withDuration: 0.3) {
                view.transform = CGAffineTransform.identity
            }
        }
    }
    
    // MARK: - Private helper functions
    
    private func setupImageView() {
        let imageView = UIImageView(image: self.image)
        view.addSubview(imageView)
        
        // Setup display properties
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        
        // Setup anchors
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        addPinchGestureTo(view: imageView)
    }
    
    private func setupNavigationBar() {
        // Set title display mode to small and turn on hiding of nav bar on tap
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.hidesBarsOnTap = true
    }
    
    private func addPinchGestureTo(view: UIView) {
        // Add pinch gesture recogniser to imageView
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(sender:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(pinchGesture)
    }

}
