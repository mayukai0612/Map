//
//  WeatherCell.swift
//  Map
//
//  Created by Yukai Ma on 31/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    
    @IBOutlet weak var tempLabel: UILabel!
    

    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var windImage: UIImageView!
    @IBOutlet weak var weatherImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
