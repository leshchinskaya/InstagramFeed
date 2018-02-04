//
//  InstagramAPI.swift
//  InstagramFeed
//
//  Created by Marie on 04.02.18.
//  Copyright © 2018 Mariya. All rights reserved.
//

import Foundation

class InstagramAPI {
    
    struct Media {
        let takenPhoto: String
        let user_id: String
        let username: String
        let avatarURL: String
        let caption: String
        let comments: [String]
        let time: Int
        let likes: Int
    }
    
    struct Comment {
        let fromUserName: String
        let text: String
    }
    
    struct User {
        let posts: Int
        let followers: Int
        let following: Int
    }
    
}
