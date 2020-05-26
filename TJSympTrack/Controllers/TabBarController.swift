//
//  TabBarController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 5/12/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import Foundation

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tabBarController?.selectedIndex = 1
        self.selectedIndex = 1
    }
}
