//
//  ViewController.swift
//  zoi-swift
//
//  Created by Tomohiro Nishimura on 2015/01/29.
//  Copyright (c) 2015年 Tomohiro Nishimura. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    let zoiURL = NSURL(string: "http://zoi.herokuapp.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        
        let request = NSURLRequest(URL: self.zoiURL!)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tweetTapped(sender: AnyObject) {
        let href = self.webView.stringByEvaluatingJavaScriptFromString("document.querySelector('h1.text-center > a').href")
        self.tweet(NSURL(string: href!)!)
    }
    
    func tweet(tweetURL: NSURL) {
        var query : [String: String] = [:]
        var pairs = tweetURL.query?.componentsSeparatedByString("&")
        if pairs == nil {
            return
        }
        for pair in pairs! {
            let keyValue = pair.componentsSeparatedByString("=")
            query[keyValue[0]] = keyValue[1]
        }
        
        let pic = "http://" + query["text"]!
        let picCount = countElements(pic)
        let picIndex = advance(pic.startIndex, picCount - 4)
        
        let hashtag = "#" + query["hashtags"]!
        
        var vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc.addURL(NSURL(string: pic.substringToIndex(picIndex)))
        vc.addURL(self.zoiURL)
        vc.setInitialText("\(self.zoiURL!) \(hashtag)")
        
        presentViewController(vc, animated: true, completion: nil)
    }

    // MARK: - UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL.host == "twitter.com" {
            self.tweet(request.URL)
            return false
        }
        
        self.navigationItem.leftBarButtonItem?.enabled = false
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.navigationItem.leftBarButtonItem?.enabled = true
    }
}

