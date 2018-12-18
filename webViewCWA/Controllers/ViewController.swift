//
//  ViewController.swift
//  webViewCWA
//
//  Created by Blair Myers on 9/10/18.
//  Copyright © 2018 Blair Myers. All rights reserved.
//

import UIKit
import WebKit
import MessageUI
import BTNavigationDropdownMenu

class ViewController: UIViewController, UIGestureRecognizerDelegate, WKNavigationDelegate, UIWebViewDelegate {
    
    // Keeps track of navigation history for forward/back options
    var navigationTracker : Int = 0
    
    // webview wrapper that CWA is contained in
    var webView : WKWebView!
    
    // Array to keep track of webviews just for reference sake
    var webViewArray = [UIView()]
    
    // Keeps track of the current webview in front for reference sake
    var currentView : UIView!
    
    var second = SecondViewController()
    
    var tabBar = TabBarController()
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Options for dropdown menu list
    let items = ["Refresh", "Help", "Email", "Logout", "Transactions", "Trips"]
    
    // Implement behavior for back button
    @IBAction func goBack(_ sender: Any) {
        navigationHandler()
    }
    
    
    override func loadView() {
        self.view = webView
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeSwipers()
        initializeTaps()
        initializeMenu()
        
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //activityIndicator.startAnimating()
        //activityIndicator.hidesWhenStopped = true
        
        self.webView.load(NSURLRequest(url: URL(string: "https://www15.swalifeqa.com/PortalWeb/cwa.jsp?test=test")!) as URLRequest)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    
    
    //MARK: Functions
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping(WKNavigationActionPolicy) -> Void) {
        
        if let urlString = navigationAction.request.url?.absoluteString {
            
            let urlSize = urlString.count
            var cwaPage : String = ""
            var startIndex : String.Index = urlString.index(urlString.startIndex, offsetBy: 1)
            
            if urlSize > 40 {
                startIndex = urlString.index(urlString.startIndex, offsetBy: 41)
            }
            let endIndex : String.Index
            
            if urlString.suffix(2) == "do" {
                endIndex = urlString.index(urlString.startIndex, offsetBy: urlSize - 4)
                cwaPage = String(urlString[startIndex...endIndex])
                navigationTracker += 1
            }
            else if urlString.suffix(3) == "do#" || urlString.suffix(3) == "do?" {
                endIndex = urlString.index(urlString.startIndex, offsetBy: urlString.count - 5)
                cwaPage = String(urlString[startIndex...endIndex])
                navigationTracker += 1
            }
            
            if cwaPage == "login" {
                //backButton.isEnabled = true
                webView.evaluateJavaScript("window.scrollTo(0,0)", completionHandler: nil)
                webView.scrollView.zoomScale = 0.60
            }
        }
        decisionHandler(.allow)
    }
    
    func initializeMenu() {
        let menuView = BTNavigationDropdownMenu(title: "Menu", items: items)
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self!.handleMenuOptions(index: indexPath)
        }
    }
    
    // Called when user selects an item from toolbar menu
    func handleMenuOptions(index: Int) {
        
        switch index {
        // Reload
        case 0:
            webView.reload()
        // Help
        case 1:
            let url = URL(string: "https://wwww.southwest.com")
            UIApplication.shared.open(url!, options: [:])
        // Email
        case 2:
            let email = "blair.myers@wnco.com"
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        // Logout
        case 3:
            let logURL = URL(string: "https://www15.swalifeqa.com/csswa/ea/plt/endSession.jsp")
            let logRequest = URLRequest(url: logURL!)
            self.webView.load(logRequest)
        // Transactions
        case 4:
            let tranURL = URL(string: "https://www15.swalifeqa.com/csswa/ea/plt/getCrewMemberTransactionReport.do")
            let tranRequest = URLRequest(url: tranURL!)
            self.webView.load(tranRequest)
        // Trips
        case 5:
            let tripURL = URL(string: "https://www15.swalifeqa.com/csswa/ea/plt/crewMemberSearch.do?popup=true&searchID=43209&searchFor=accessCrewBoard&searchName=&searchBase=&searchPosition=")
            let tripRequest = URLRequest(url: tripURL!)
            self.webView.load(tripRequest)
        default:
            break
        }
    }
    
    func navigationHandler() {
        if self.webView.canGoBack && navigationTracker > 0 {
            self.webView.goBack()
            navigationTracker -= 1
        }
        else if webViewArray.count > 1 {
            currentView.removeFromSuperview()
            webViewArray.removeLast()
            navigationTracker = 0
        }
        else if self.webView.canGoBack {
            self.webView.goBack()
            navigationTracker = 0
        }
        else {
            //backButton.isEnabled = false
        }
    }
    
    // Enables gesture recognizers - needed for swipes and taps
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func initializeSwipers() {
        _ = initializeSwipeGestures(direction: UISwipeGestureRecognizerDirection.right)
        _ = initializeSwipeGestures(direction: UISwipeGestureRecognizerDirection.left)
    }
    
    func initializeSwipeGestures(direction: UISwipeGestureRecognizerDirection) -> UISwipeGestureRecognizer {
        
        let swiper = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swiper.direction = direction
        self.view.addGestureRecognizer(swiper)
        return swiper
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                navigationHandler()
            case UISwipeGestureRecognizerDirection.left:
                if self.webView.canGoForward {
                    self.webView.goForward()
                    navigationTracker += 1
                }
            default:
                break
            }
        }
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
        }
        else if sender.numberOfTapsRequired == 3 {
        }
        else if sender.numberOfTapsRequired == 4 {
        }
    }
    
}

extension ViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if let urlString = navigationAction.request.url?.absoluteString {
        }
        navigationTracker = 0
        let newWebView = WKWebView(frame: self.webView.frame, configuration: configuration)
        view.addSubview(newWebView)
        //backButton.isEnabled = true
        webViewArray.append(newWebView)
        currentView = newWebView
        
        second.view = newWebView
        return newWebView
    }
}
