//
//  SecondViewController.swift
//  webViewCWA
//
//  Created by Blair Myers on 11/12/18.
//  Copyright © 2018 Blair Myers. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController, UIGestureRecognizerDelegate, WKNavigationDelegate, UIWebViewDelegate{
    
    var webView2: WKWebView!

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currentView: UIView!
    
    var numberOfThings : Int = 5
    
    override func loadView() {
        self.view = webView2
        let config = WKWebViewConfiguration()
        webView2 = WKWebView(frame: .zero, configuration: config)
        webView2.navigationDelegate = self
        view = webView2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.webView2.load(NSURLRequest(url: URL(string: "https://www15.swalifeqa.com/PortalWeb/cwa.jsp?test=test")!) as URLRequest)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
