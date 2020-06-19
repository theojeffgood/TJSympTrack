//
//  TableLoadingAnimation.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 6/12/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit

extension UITableView {
   
   func animateTable() {
      self.reloadData()
       let cells = self.visibleCells

       let tableViewHeight = self.bounds.size.height

       for cell in cells {
           cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
       }

       var delayCounter = 0
       for cell in cells {
           UIView.animate(withDuration: 1.25, delay: Double(delayCounter) * 0.04, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
               cell.transform = CGAffineTransform.identity
           }, completion: nil)
           delayCounter += 1
       }
   }
}
