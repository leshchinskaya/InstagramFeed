//
//  DetailPhotoViewController.swift
//  InstagramFeed
//
//  Created by Marie on 04.02.18.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController {
    
    var photo: NSDictionary?
    var imageView: UIImageView?
    var animator: UIDynamicAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: -320, width: self.view.bounds.size.width, height: self.view.bounds.size.width))
        self.view.addSubview(imageView!)
        
        if let photoDictionary = photo {
            InstagramData.imageForPhoto(photoDictionary: photoDictionary, size: "standard_resolution", completion:  {(image) -> Void in
                self.imageView!.image = image
            })
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        let snap = UISnapBehavior(item: self.imageView!, snapTo: self.view.center)
        self.animator?.addBehavior(snap)
    }
    
    @objc func close() {
        self.animator?.removeAllBehaviors()
        
        let rect = self.view.bounds
        let snap = UISnapBehavior(item: self.imageView!, snapTo: CGPoint(x: rect.midX, y: rect.maxY + 100 ))
        
        self.animator?.addBehavior(snap)
        
        self.dismiss(animated: true, completion: nil)
    }
}
