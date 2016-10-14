//
//  AnimalInfoCell.swift
//  Map
//
//  Created by Yukai Ma on 17/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class AnimalInfoCell: UITableViewCell {

    
  
//  
//    var img = UIImageView()
//    var animalName = UILabel()
//    var eventDate = UILabel()
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        img.backgroundColor = UIColor.blueColor()
//        
//        img.translatesAutoresizingMaskIntoConstraints = false
//        animalName.translatesAutoresizingMaskIntoConstraints = false
//        eventDate.translatesAutoresizingMaskIntoConstraints = false
//        
//        contentView.addSubview(img)
//        contentView.addSubview(animalName)
//        contentView.addSubview(eventDate)
//        
//        let viewsDict = [
//            "image" : img,
//            "animalname" : animalName,
//            "eventdata" : eventDate
//            ]
//        
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[image(10)]", options: [], metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[image(10)]-|", options: [], metrics: nil, views: viewsDict))
//
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[eventdate]-|", options: [], metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[eventdate]-|", options: [], metrics: nil, views: viewsDict))
//
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[animalname]", options: [], metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[animalname]-[image(10)]-|", options: [], metrics: nil, views: viewsDict))
//    }
    
    let padding: CGFloat = 5
    var background: UIView!
    var riskImageView: UIImageView!
    var nameLabel: UILabel!
    var dateLabel: UILabel!
    var hintLabel: UILabel!
    
//    var stock: Stock? {
//        didSet {
//            if let s = stock {
//                background.backgroundColor = s.backgroundColor
//                priceLabel.text = s.price
//                priceLabel.backgroundColor = s.priceLabelColor
//                typeLabel.text = s.action
//                typeLabel.backgroundColor = s.typeColor
//                nameLabel.text = s.name
//                setNeedsLayout()
//            }
//        }
//    }
    
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
        contentView.addSubview(nameLabel)
        
        riskImageView = UIImageView(frame: CGRectZero)
        contentView.addSubview(riskImageView)
        
        dateLabel = UILabel(frame: CGRectZero)
        dateLabel.textAlignment = .Center
        dateLabel.textColor = UIColor.blackColor()
        contentView.addSubview(dateLabel)
        
        hintLabel = UILabel(frame: CGRectZero)
        hintLabel.textAlignment = .Center
        hintLabel.textColor = UIColor.blackColor()
        contentView.addSubview(hintLabel)
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
        nameLabel.frame = CGRectMake(padding + 5 , padding, frame.width - 50 , frame.height/2 - 10)
        dateLabel.frame = CGRectMake(padding, nameLabel.frame.height + 20, 100,30)
        riskImageView.frame = CGRectMake(frame.width  - 75, padding, 40, 40)
        hintLabel.frame = CGRectMake(frame.width  - 115, riskImageView.frame.height + 7, 115, 40)

    }
}
