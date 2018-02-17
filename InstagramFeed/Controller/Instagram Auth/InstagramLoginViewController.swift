//
//  InstagramLoginViewController.swift
//  InstagramFeed
//
//  Created by Marie on 01.02.18.
//  Copyright © 2018 Mariya. All rights reserved.
//

import UIKit

class InstagramLoginViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loginWebView: UIWebView!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginSuccess: UILabel!
    
    var accessToken: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loginWebView.delegate = self
        unSignedRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - unSignedRequest
    func unSignedRequest () {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        loginWebView.loadRequest(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
        accessToken = authToken
        if (authToken == "") {
            accessToken = "4625589.3e1a01f.47608692b7054008bba207b91370703a"
        }
        loginSuccess.text = "login success ✔︎"
        print("Instagram authentication token ==", accessToken)
        
        let tbvc = self.tabBarController  as! InstaTabController
        tbvc.accessToken = accessToken
    }
    
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = false
        loginIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loginIndicator.isHidden = true
        loginIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }

}
