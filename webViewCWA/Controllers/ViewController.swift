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

class ViewController: UIViewController, UIGestureRecognizerDelegate, WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate {
    
    var navigationTracker : Int = 0
    var webView : WKWebView!
    var webViewArray = [UIView()]
    var currentView : UIView!
    var contentView: UIView!
    var contents = ""
    
    var currentURL : String = ""
    
    let preferences = WKPreferences()
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var loadCounter = 0
    
    // Options for dropdown menu list
    let items = ["Refresh", "Help", "Email", "Logout", "Login", "Transactions", "Trips"]
    
    // Implement behavior for back button
    @IBAction func goBack(_ sender: Any) {
        navigationHandler()
    }
    
    
    override func loadView() {
        self.view = webView
        let config = WKWebViewConfiguration()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        preferences.javaScriptEnabled = true
        config.preferences = preferences
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeSwipers()
        initializeMenu()
        modifyGestureRecognizers()
        
        if let path = Bundle.main.path(forResource: "Tap", ofType: "js") {
            do {
                contents = try String(contentsOfFile: path)
                print(contents)
            } catch {
                print("catch")
            }
        } else {
            print("error")
        }
        
        //webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //activityIndicator.startAnimating()
        //activityIndicator.hidesWhenStopped = true
        
        self.webView.load(URLRequest(url: URL(string: "https://www15.swalifeqa.com/PortalWeb/cwa.jsp?test=test")!) as URLRequest)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
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
            if webViewArray.count > 1 {
                currentView.removeFromSuperview()
                webViewArray.removeLast()
            }
            let logURL = URL(string: "https://www15.swalifeqa.com/csswa/ea/plt/endSession.jsp")
            let logRequest = URLRequest(url: logURL!)
            self.webView.load(logRequest)
        // Login
        case 4:
            let loginURL = URL(string: "https://www15.swalifeqa.com/PortalWeb/cwa.jsp?test=test")
            let loginRequest = URLRequest(url: loginURL!)
            self.webView.load(loginRequest)
        // Transactions
        case 5:
            let tranURL = URL(string: "https://www15.swalifeqa.com/csswa/ea/plt/getCrewMemberTransactionReport.do")
            let tranRequest = URLRequest(url: tranURL!)
            self.webView.load(tranRequest)
        // Trips
        case 6:
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
            backButton.isEnabled = false
        }
    }
    
    // Enables gesture recognizers - needed for swipes and taps
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func initializeSwipers() {
        _ = initializeSwipeGestures(direction: UISwipeGestureRecognizer.Direction.right)
        _ = initializeSwipeGestures(direction: UISwipeGestureRecognizer.Direction.left)
    }
    
    func initializeSwipeGestures(direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        
        let swiper = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swiper.direction = direction
        self.view.addGestureRecognizer(swiper)
        return swiper
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizer.Direction.right:
                navigationHandler()
            case UISwipeGestureRecognizer.Direction.left:
                if self.webView.canGoForward {
                    self.webView.goForward()
                    navigationTracker += 1
                }
            default:
                break
            }
        }
    }
    
    func modifyGestureRecognizers() {
        let tripleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTripleTap(gesture:)))
        tripleTapGesture.numberOfTouchesRequired = 1
        tripleTapGesture.numberOfTapsRequired = 3
        let quadTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleQuadTap(gesture:)))
        quadTapGesture.numberOfTouchesRequired = 1
        quadTapGesture.numberOfTapsRequired = 4
        
        self.webView.addGestureRecognizer(tripleTapGesture)
        self.webView.addGestureRecognizer(quadTapGesture)
        
        var count = 0
        var views = self.webView.subviews
        while !views.isEmpty {
            
            count += 1
            let v = views.removeFirst()
            if let gestures = v.gestureRecognizers {
                for g in gestures {
                    if let tapGesture = g as? UITapGestureRecognizer {
                        if tapGesture.numberOfTapsRequired == 2 && tapGesture.numberOfTouchesRequired == 1 {
                            tapGesture.removeTarget(nil, action: nil)
                            tapGesture.addTarget(self, action: #selector(handleDoubleTap(gesture:)))
                            tapGesture.require(toFail: tripleTapGesture)
                            contentView = v
                        }
                    }
                }
            }
            views += v.subviews
        }
        if contentView == nil {
            fatalError("Cannot continue without contentView.")
        }
        print(count)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let requestedURL = navigationAction.request.url
        
        
        if navigationAction.navigationType == .linkActivated {
            print("OK")
            modifyGestureRecognizers()
            if let path = Bundle.main.path(forResource: "Tap", ofType: "js") {
                do {
                    contents = try String(contentsOfFile: path)
                    print(contents)
                } catch {
                    print("catch")
                }
            } else {
                print("error")
            }
            if requestedURL?.absoluteString.contains("doubleclick.net") == true {
                UIApplication.shared.open(requestedURL!, options: [:], completionHandler: nil)
            }
        }
        decisionHandler(.allow)
    }
    
    @objc func handleDoubleTap(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            print("double click")
            let tapPoint = tapPointFor(gesture: gesture)
            let script = "performDoubleClickAtPoint(\(tapPoint.x), \(tapPoint.y));"
            self.webView.evaluateJavaScript(contents, completionHandler: nil)
            self.webView.evaluateJavaScript(script, completionHandler: nil)
        }
    }
    
    @objc func handleTripleTap(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let script = "shiftToTopLeft();"
            self.webView.evaluateJavaScript(contents, completionHandler: nil)
            self.webView.evaluateJavaScript(script, completionHandler: nil)
        }
    }
    
    @objc func handleQuadTap(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let tapPoint = tapPointFor(gesture: gesture)
            let script = "performCommandClickAtPoint(\(tapPoint.x), \(tapPoint.y));"
            self.webView.evaluateJavaScript(script, completionHandler: nil)
        }
    }
    
    func tapPointFor(gesture: UITapGestureRecognizer) -> CGPoint {
        var tapPoint = gesture.location(in: contentView)
        tapPoint.x = tapPoint.x.rounded()
        tapPoint.y = tapPoint.y.rounded()
        return tapPoint
    }
    
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        let newWebView = WKWebView(frame: self.webView.frame, configuration: configuration)
        
        func noNewTab(alert: UIAlertAction!) {
            view.addSubview(newWebView)
            navigationTracker = 0
            backButton.isEnabled = true
            webViewArray.append(newWebView)
            currentView = newWebView
        }
        
        func newTab(alert: UIAlertAction!) {
            view.addSubview(newWebView)
        }
        
        let alertController = UIAlertController(title: "Open in new tab?", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: newTab))
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: noNewTab))
        self.present(alertController, animated: true, completion: nil)
        return newWebView
    }
}


