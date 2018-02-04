//
//  ExplorePhotoCollectionViewCell.swift
//  InstagramFeed
//
//  Created by Marie on 30.01.18.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class ExplorePhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesOfCount: UILabel!
    
    var photo: AnyObject! {
        didSet {
            InstagramData.imageForPhoto(photoDictionary: photo, size: "thumbnail") { (image) -> Void in
                self.imageView.image = image
            }
        }
    }
    
    var likes: String! {
        didSet {
            self.likesOfCount.text = "😍 " + likes + " likes"
            }
        }
}
