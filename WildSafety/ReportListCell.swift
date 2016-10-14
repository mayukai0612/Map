//
//  ReportListCell.swift
//  Map
//
//  Created by Yukai Ma on 18/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit


class ReportListCell: UITableViewCell {


    @IBOutlet weak var categoryImageView: UIImageView!
    
    
    @IBOutlet weak var reportTitle: UILabel!
    
    
    
    @IBOutlet weak var reportTime: UILabel!
    
    
    @IBOutlet weak var reportLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
