//
//  SymptomCell.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit

class SymptomCell: UITableViewCell {
    
    @IBOutlet weak var symptomLabel: UILabel!
    @IBOutlet weak var symptomCheckmark: UIImageView!
    @IBOutlet weak var symptomCheckCircle: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
