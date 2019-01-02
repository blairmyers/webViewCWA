//
//  SecondViewController.swift
//  webViewCWA
//
//  Created by Blair Myers on 11/12/18.
//  Copyright © 2018 Blair Myers. All rights reserved.
//

import UIKit
import WebKit
import BTNavigationDropdownMenu


class SecondViewController: UIViewController, UIGestureRecognizerDelegate, WKNavigationDelegate, UIWebViewDelegate { // Might need ViewReceiver also
    
    var webView: WKWebView!
    var currentView: UIView!
    var currentURL: String!

    override func loadView() {
        self.view = webView
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        //preferences.javaScriptCanOpenWindowsAutomatically = true
        //preferences.javaScriptEnabled = true
        //config.preferences = preferences
        // Don't know what this does
        webView.navigationDelegate = self // LOOK INTO THIS LINE
        view = webView  // Might be repetitive
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTaps()
        
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        loadURL(url: "https://www15.swalifeqa.com/PortalWeb/cwa.jsp?test=test")
    }
    
    func viewReceived(data: String) {
        var webView2: WKWebView!
        webView.addSubview(webView2)
        /*self.view = webView2
        let config = WKWebViewConfiguration()
        webView2 = WKWebView(frame: .zero, configuration: config)
        webView2.navigationDelegate = self
        view = webView2
        super.viewDidLoad()*/
        let loadURL = URL(string: "https://www.apple.com")
        let loadRequest = URLRequest(url: loadURL!)
        print("hello")
        webView2.load(loadRequest)
    }
    
    
    
    
    
    //MARK: Functions
    
    func loadURL(url: String) {
        let loadURL = URL(string: url)
        let loadRequest = URLRequest(url: loadURL!)
        //super.loadView()
        if webView == nil {
            print("webView is nil")
        }
        self.webView.load(loadRequest)
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping(WKNavigationActionPolicy) -> Void) {
        
        if let urlString = navigationAction.request.url?.absoluteString {
            currentURL = urlString
            
            let urlSize = urlString.count
            var cwaPage: String!
            var startIndex = urlString.index(urlString.startIndex, offsetBy: 1)
            let endIndex : String.Index
            
            if urlSize > 40 {
                startIndex = urlString.index(urlString.startIndex, offsetBy: 41)
            }
            
            if urlString.suffix(2) == "do" {
                endIndex = urlString.index(urlString.startIndex, offsetBy: urlSize - 4)
                cwaPage = String(urlString[startIndex...endIndex])
            }
            else if urlString.suffix(3) == "do#" || urlString.suffix(3) == "do?" {
                endIndex = urlString.index(urlString.startIndex, offsetBy: urlString.count - 5)
                cwaPage = String(urlString[startIndex...endIndex])
            }
            
            if cwaPage == "login" {
                webView.evaluateJavaScript("window.scrollTo(0,0)", completionHandler: nil)
                webView.scrollView.zoomScale = 0.60
            }
        }
        decisionHandler(.allow)
    }
    
    // Enables gesture recognizers - needed for swipes and taps
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func initializeTaps() {
        let quadTap = initializeTapGestures(toFailGestureRecognizer: nil, numberOfTaps: 4)
        let tripleTap = initializeTapGestures(toFailGestureRecognizer: quadTap, numberOfTaps: 3)
        let doubleTap = initializeTapGestures(toFailGestureRecognizer: tripleTap, numberOfTaps: 2)
        _ = initializeTapGestures(toFailGestureRecognizer: doubleTap, numberOfTaps: 1)
    }
    
    func initializeTapGestures(toFailGestureRecognizer: UITapGestureRecognizer?, numberOfTaps: Int) -> UITapGestureRecognizer {
        
        let tapper = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tapper.delegate = self
        tapper.numberOfTapsRequired = numberOfTaps
        
        if numberOfTaps < 4 {
            tapper.require(toFail: toFailGestureRecognizer!)
        }
        
        webView.addGestureRecognizer(tapper)
        return tapper
    }
    
    @objc func tapAction(sender: UITapGestureRecognizer) -> Void {
        
        //let zoomScale = webView.scrollView.zoomScale
        //let contentOffset = webView.scrollView.contentOffset
        //let coordinates = sender.location(in: self.view)
        
        if sender.numberOfTapsRequired == 1 {
        }
        else if sender.numberOfTapsRequired == 2 {
            webView.evaluateJavaScript("openCrewMemberBoard()", completionHandler: nil)
            
        }
        else if sender.numberOfTapsRequired == 3 {
        }
        else if sender.numberOfTapsRequired == 4 {
        }
    }
    
    /*var webView2: WKWebView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currentView: UIView!
    
    var numberOfThings : Int = 5
    
    var urlString: String = ""
    
    override func loadView() {
        self.view = webView2
        let config = WKWebViewConfiguration()
        webView2 = WKWebView(frame: .zero, configuration: config)
        webView2.navigationDelegate = self
        view = webView2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        //self.view.addSubview(webView2)
        if webView2 == nil {
            print("webView2 is nil 1")
        }

        self.webView2.load(URLRequest(url: URL(string: "https://www15.swalifeqa.com/PortalWeb/cwa.jsp?test=test")!))
        
        if webView2 == nil {
            print("webView2 is nil 2")
        }
        // Do any additional setup after loading the view.
    }
    
    func viewReceived(data: URL) {
        webView2.load(URLRequest(URL: data))
    }
    
    func printHello() {
        print("hello")
    }
    
    func loadApple(urlToOpen: String) {
        
        loadView()
        viewDidLoad()
        let openURL = URL(string: urlToOpen)
        let openRequest = URLRequest(url: openURL!)
        self.webView2.load(openRequest)
    }*/

}
