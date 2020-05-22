//
//  TabBarController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 5/12/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
//    var selectedSymptomsViewController: SelectedSymptomsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 1
//        selectedSymptomsViewController = SelectedSymptomsViewController()
        
//        removeTabBarTitles()
    }
    
//    func removeTabBarTitles(){
//        for tabBarItem in tabBar.items! {
//            tabBarItem.title = ""
//            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        }
//    }
    
}
