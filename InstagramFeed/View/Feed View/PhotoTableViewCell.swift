//
//  PhotoTableViewCell.swift
//  InstagramFeed
//
//  Created by Marie on 31.01.18.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var info: UILabel!
    
    var media: InstagramAPI.Media? {
        didSet {
            if let setMedia = media {
                info.text = setMedia.caption
                likes.text = "😍 " + String(setMedia.likes) + " likes"
                if let url = NSURL(string: setMedia.takenPhoto) {
                    photo.setImageWith(url as URL)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
