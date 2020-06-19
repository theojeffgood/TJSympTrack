//
//  UILabelExtensionSetFont.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 5/29/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit

extension UILabel {
   func setFontSize (){
      UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.boldSystemFont(ofSize: 25)
   }
}
