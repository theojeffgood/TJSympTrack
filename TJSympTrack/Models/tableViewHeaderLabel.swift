//
//  tableViewHeaderLabel.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 6/12/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit

class tableViewHeaderLabel: UILabel {
   
   override init(frame: CGRect){
      super.init(frame: frame)
      
      backgroundColor = .white
      textColor = .black
      font = UIFont.boldSystemFont(ofSize: 20.0)
      numberOfLines = 0
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
