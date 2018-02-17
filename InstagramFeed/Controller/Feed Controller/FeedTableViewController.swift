//
//  FeedTableViewController.swift
//  InstagramFeed
//
//  Created by Marie on 31.01.18.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    @IBOutlet weak var userFollowing: UILabel!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userPosts: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileView: UIView!
    
    var medias: [InstagramAPI.Media] = []
    var accessToken: String = ""

    var userID = "1"
    var profilePicture = "1"
    var userName = "1"
    
    struct Storyboard {
        static let photoCell = "PhotoCell"
        static let commentCell = "CommentCell"
        static let headerCell = "HeaderCell"
    }
    
    func updateUserInfo() {
        InstagramAPI().fetchUserInfo(accessToken: self.accessToken, callback: { userProfile in
            self.userID = userProfile.id
            self.userName = userProfile.username
            self.navigationItem.title = self.userName
            self.profilePicture = userProfile.profilePicture
        })
    }
    
    func updateData() {
        InstagramAPI().fetchUserData(accessToken: self.accessToken, callback: { userProfile in
            self.userFollowers.text = "Followers: " + String(userProfile.followers)
            self.userFollowers.font = UIFont(name: "AvenirNext-Regular", size: 14)
                
            self.userFollowing.font = UIFont(name: "AvenirNext-Regular", size: 14)
            self.userFollowing.text = "Following: " + String(userProfile.following)
                
            self.userPosts.font = UIFont(name: "AvenirNext-Regular", size: 14)
            self.userPosts.text = "Posts: " + String(userProfile.posts)
                
            if let url = NSURL(string: self.profilePicture), let data = NSData(contentsOf: url as URL), let photo = UIImage(data: data as Data) {
                    self.userImage.image = photo
            } else {
                self.userImage.image = UIImage(named: "feed.png")
            }
        })
            
        DispatchQueue.main.async {
            InstagramAPI().fetchRecentMediaData(accessToken: self.accessToken, callback: { (medias: [InstagramAPI.Media]) -> Void in
                self.medias = medias
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 450
        tableView.rowHeight = UITableViewAutomaticDimension

        self.tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: Storyboard.headerCell)
        
        tableView.tableHeaderView = self.profileView
        
        self.userImage.layer.borderWidth = 1
        self.userImage.layer.masksToBounds = false
        self.userImage.layer.cornerRadius = self.userImage.frame.height / 2
        self.userImage.clipsToBounds = true

        let tbvc = self.tabBarController  as! InstaTabController
        accessToken = tbvc.accessToken
        
        updateUserInfo()
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: Selector("updateData"), for: UIControlEvents.valueChanged)
        self.tableView!.addSubview(refreshControl!)
        
        updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return medias.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.photoCell, for: indexPath) as! PhotoTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.media = medias[indexPath.section]
            
        return cell
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.headerCell) as! HeaderTableViewCell
        var frame = cell.frame
        frame.size.height = 50
        cell.frame = frame
        cell.header = medias[section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        footerView.backgroundColor = UIColor.black
        
        return footerView
    }

}
