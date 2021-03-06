//
//  EmptyViewTableview.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 5/14/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit

extension UITableView {
   
   func setEmptyMessage(_ message: String) {
      let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
      
      let imgView = UIImageView()
      imgView.image = UIImage(named: "Medical Clipboard.png")
      emptyView.addSubview(imgView)
      imgView.translatesAutoresizingMaskIntoConstraints = false
      imgView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
      imgView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
      
      let messageLabel = UILabel()
      messageLabel.translatesAutoresizingMaskIntoConstraints = false
      messageLabel.textColor = UIColor.black
      messageLabel.font = UIFont.systemFont(ofSize: 17.0)
      emptyView.addSubview(messageLabel)
      messageLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 20).isActive = true
      messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
      messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
      messageLabel.text = message
      messageLabel.numberOfLines = 0
      messageLabel.textAlignment = .center
      
      self.backgroundView = emptyView
      self.separatorStyle = .none
   }
   
   func restore() {
      self.backgroundView = nil
      self.separatorStyle = .singleLine
   }
}
