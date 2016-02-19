//
//  ViewController.swift
//  HackingWithSwift-04
//
//  Created by Robin on 2/19/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = NSURL(string: "https://www.apple.com")!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .Plain, target: self, action: Selector("openTapped"))
        
        
        progressView = UIProgressView(progressViewStyle: .Default)
        progressView.sizeToFit()
        
        let progress = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: webView, action: Selector("reload"))
        
        toolbarItems = [progress, spacer, refresh]
        navigationController?.toolbarHidden = false
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    func openTapped() {
        let ac = UIAlertController(title: "Open Page", message: nil, preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: "apple.com.cn", style: .Default, handler: openPage))
        ac.addAction(UIAlertAction(title: "robinchao.github.io", style: .Default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func openPage(action: UIAlertAction) {
        let url = NSURL(string: "https://" + action.title!)!
        webView.loadRequest(NSURLRequest(URL: url))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

