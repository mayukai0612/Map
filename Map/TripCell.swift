//
//  TripCell.swift
//  Map
//
//  Created by Yukai Ma on 27/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class TripCell: UITableViewCell {

    @IBOutlet weak var tripCategory: UIImageView!
    
    @IBOutlet weak var tripDate: UILabel!
    
    @IBOutlet weak var tripTitleLable: UILabel!
    
    @IBOutlet weak var tripLocLable: UILabel!
    
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
    
        override func setSelected(selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
    
            // Configure the view for the selected state
        }
    
    
}
