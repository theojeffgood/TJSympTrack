//
//  UIBUttonExtensionSetAlpha.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 5/14/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit

extension UIButton {
   
   override open var isEnabled: Bool{
      didSet {
         self.alpha = isEnabled ? 1.0 : 0.55
      }
   }
}
