//
//  UIImageResizeExtension.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/25/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import func AVFoundation.AVMakeRect

//Techniques for resizing images, below. This extension uses #1
//    Time (seconds)
//Technique #1: UIKit   0.1420
//Technique #2: Core Graphics 1   0.1722
//Technique #3: Image I/O   0.1616
//Technique #4: Core Image 2   2.4983
//Technique #5: vImage   2.3126
//outlined at https://nshipster.com/image-resizing/

extension UIImage {
   
   func reSize(newSize: CGSize) -> UIImage {
      
      let rect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(origin: .zero, size: newSize))
      
      let renderer = UIGraphicsImageRenderer(size: newSize)
      let resizedImage = renderer.image { (context) in
         self.draw(in: rect)
      }
      return resizedImage
   }
}
