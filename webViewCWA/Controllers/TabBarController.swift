//
//  TabBarController.swift
//  webViewCWA
//
//  Created by Blair Myers on 11/12/18.
//  Copyright © 2018 Blair Myers. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class TabBarController: UITabBarController {
    
    let items = ["Refresh", "Help", "Email", "Logout", "Transactions", "Trips"]
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
