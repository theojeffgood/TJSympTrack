//
//  UIImageResizeExtension.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/25/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scaleImageToSize(img: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        img.draw(in: (CGRect(origin: CGPoint.zero, size: size)))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

