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
    
    //medias struct (from media api from instagram)
    struct Media {
        let takenPhoto: String
        let user_id: String
        let username: String
        let avatarURL: String
        let caption: String
        let time: Int
        let likes: Int
    }
    
    //user info (from media api from instagram)
    struct User {
        let posts: Int
        let followers: Int
        let following: Int
    }
    
    struct UserInfo {
        let id: String
        let username: String
        let profilePicture: String
    }
    
    
    //Media information
    func populateMediaWith(data: AnyObject?, callback: ([Media]) -> Void) {
        var medias = [Media]()
        
        let json = JSON(data!)["data"]

        for item in json.arrayValue {
            medias.append(Media(takenPhoto: item["images"]["standard_resolution"]["url"].stringValue, user_id: item["user"]["id"].stringValue, username: item["user"]["username"].stringValue, avatarURL: item["user"]["profile_picture"].stringValue, caption: item["caption"]["text"].stringValue, time: item["created_time"].intValue, likes: item["likes"]["count"].intValue))
        }
        
        callback(medias)
    }
    
    //FETCH USER PROFILE DATA
    func fetchUserData(accessToken: String, callback: @escaping (User) -> Void) {
        request("https://api.instagram.com/v1/users/self/?access_token=\(accessToken)").responseJSON { (response) -> Void in
            self.populateUserProfileWith(data: response.result.value! as AnyObject, callback: callback)
        }
    }
    
    func fetchUserInfo (accessToken: String, callback: @escaping (UserInfo) -> Void) {
        request("https://api.instagram.com/v1/users/self?access_token=\(accessToken)").responseJSON { (response) -> Void in
            self.infoUserProfileWith(data: response.result.value! as AnyObject, callback: callback)
        }
    }
    
    func infoUserProfileWith(data: AnyObject?, callback: (UserInfo) -> Void) {
        let json = JSON(data!)["data"]
        callback(UserInfo(id: json["id"].stringValue, username: json["username"].stringValue, profilePicture: json["profile_picture"].stringValue))
    }
    
    
    //populate user info
    func populateUserProfileWith(data: AnyObject?, callback: (User) -> Void) {
        let json = JSON(data!)["data"]
        callback(User(posts: json["counts"]["media"].intValue, followers: json["counts"]["followed_by"].intValue, following: json["counts"]["follows"].intValue))
    }
    
    //FETCH RECENT DATA
    func fetchRecentMediaData(accessToken: String, callback: @escaping ([Media]) -> Void) {
        request("https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accessToken)").responseJSON { (response) -> Void in
            self.populateMediaWith(data: response.result.value! as AnyObject, callback: callback)
        }
    }
    
    
}
