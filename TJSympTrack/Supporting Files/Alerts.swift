//
//  Alerts.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 5/12/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import Foundation

struct Alerts {
    
    func fireAlertWithoutAction(){
        
        let alert = UIAlertController(title: "Please add your symptom(s)", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Symptom", style: .default) { (action) in }
        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
    }
    
    func fireAlertWithAction(){
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //        DEFINE AN ACTION THAT FIRES WHEN THE ALERT CTA IS CLICKED
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
    }
}
