//
//  InstagramAPI.swift
//  InstagramFeed
//
//  Created by Marie on 04.02.18.
//  Copyright © 2018 Mariya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class InstagramAPI {
    
    let client_id = "3e1a01f8f9e44f758d83c0392295f7e0"
    
    //medias struct (from media api from instagram)
    struct Media {
        let takenPhoto: String
        let user_id: String
        let username: String
        let avatarURL: String
        let caption: String
        let comments: [Comment]
        let time: Int
        let likes: Int
    }
    
    struct Comment {
        let fromUserName: String
        let text: String
    }
    
    //user info (from media api from instagram)
    struct User {
        let posts: Int
        let followers: Int
        let following: Int
    }
    
}
