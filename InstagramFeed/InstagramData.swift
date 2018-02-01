//
//  InstagramData.swift
//  InstagramFeed
//
//  Created by Marie on 01.02.18.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class InstagramData {
    
    static func imageForPhoto (photoDictionary: AnyObject, size: String, completion: @escaping (_ image: UIImage) ->  Void) {
        
        let urlString = photoDictionary.value(forKeyPath: "images.\(size).url") as! String
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        let request = URLRequest(url: url!)
        let task = session.downloadTask(with: request) { (localFile, response, error) in
            if error == nil {
                let data = try! Data(contentsOf: localFile!)
                let image = UIImage (data: data)
                
                DispatchQueue.main.async {
                    completion(image!)
                }
            }
        }
        task.resume()
    }
    
}
