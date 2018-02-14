//
//  ExploreCollectionViewController.swift
//  InstagramFeed
//
//  Created by Marie on 30.01.18.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class ExploreCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var accessToken: String = ""
    
    private var photoDictionaries = [AnyObject]()
    var data: [[String: String?]] = []
    
    private let leftAndRightPaddings: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heightAdjustment: CGFloat = 30.0
    
    struct Storyboard {
        static let explorePhotoCell = "ExplorePhotoCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        let tbvc = self.tabBarController  as! InstaTabController
        accessToken = tbvc.accessToken
        
        print("access = \(accessToken)")
        
        //configure the search bar
        self.navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        
        //configure the collection view
        let width = (collectionView!.frame.size.width - leftAndRightPaddings) / numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
        
        fetchPhotos()
    }
    
    // MARK: - Helper Methods

    //https://api.instagram.com/v1/tags/{tag-name}/media/recent?access_token=ACCESS-TOKEN
    func urlWithSearchText(searchText: String) -> URL {
        let escaptedSearchText = searchText.replacingOccurrences(of: " ", with: "")
        let urlSring = "https://api.instagram.com/v1/tags/\(searchText)/media/recent?access_token=\(accessToken)"
        
        let url = URL(string: urlSring)
        
        return url!
    }
    
    func fetchPhotos() {
        let session = URLSession.shared
        let url: URL
        
        if !(self.searchBar.text!.isEmpty) {
            url = urlWithSearchText(searchText: self.searchBar.text!)
        } else {
            url = urlWithSearchText(searchText: "vrn")
        }
        
        let request = URLRequest(url: url)
        let task = session.downloadTask(with: request) { (localFile, response, error) in
            if error == nil {
                let data = try! Data(contentsOf: localFile!)
                
                do {
                    let responseDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    
                    self.photoDictionaries = responseDictionary["data"] as! [AnyObject]
                    print(self.photoDictionaries)
                    
                    for result in self.photoDictionaries {
                        let likes = result.value(forKeyPath: "likes.count") as! Int
                        let comment = result.value(forKeyPath: "comments.count") as! Int
                        let obj = ["comments": String(comment), "likes": String(likes)]
                        
                        self.data.append(obj)
                    }
                    
                } catch let error {
                    print (error)
                }
            }
            DispatchQueue.main.async {
               self.collectionView?.reloadData()
            }
        }
        task.resume()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.photoDictionaries.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.explorePhotoCell, for: indexPath) as! ExplorePhotoCollectionViewCell
    
        // Configure the cell
        //cell.imageView.image = UIImage (named: "example")
        let photoDictionary = photoDictionaries[indexPath.item]
        cell.photo = photoDictionary
        cell.likes = data[indexPath.row]["likes"] as! String
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.photoDictionaries[indexPath.row] as! NSDictionary
        
        let viewController = DetailPhotoViewController()
        viewController.modalPresentationStyle = UIModalPresentationStyle.custom
        
        viewController.transitioningDelegate = self
        
        viewController.photo = photo
        
        self.present(viewController, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension ExploreCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            fetchPhotos()
        }
    }
}


// MARK: - UIViewControllerTransitioningDelegate
extension ExploreCollectionViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentDetailTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissDetailTransition()
    }
}
