//
//  AnimalInfoCell.swift
//  Map
//
//  Created by Yukai Ma on 17/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {
    

    let padding: CGFloat = 5
    var background: UIView!
    var nameLabel: UILabel!
    var addressLabel: UILabel!
 
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        background = UIView(frame: CGRectZero)
        background.alpha = 0.6
        contentView.addSubview(background)
        
        nameLabel = UILabel(frame: CGRectZero)
        nameLabel.textAlignment = .Left
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16)

        contentView.addSubview(nameLabel)
        
        
        addressLabel = UILabel(frame: CGRectZero)
        addressLabel.textAlignment = .Left
        addressLabel.textColor = UIColor.blackColor()
        addressLabel.font = addressLabel.font.fontWithSize(14)

        contentView.addSubview(addressLabel)
       
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        background.frame = CGRectMake(0, padding, frame.width, frame.height - 2 * padding)
        nameLabel.frame = CGRectMake(padding, padding, frame.width - 35 , frame.height/2 - 5)
        addressLabel.frame = CGRectMake(padding, nameLabel.frame.height + 5, 300,frame.height/2 - 10)
       
        
    }
}
