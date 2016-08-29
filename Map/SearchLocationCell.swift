import UIKit

class SearchLocationCell: UITableViewCell {
    
    var title: UILabel!
    var subTitle: UILabel!
  
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let gap : CGFloat = 10
        let labelHeight: CGFloat = 30
        let labelWidth: CGFloat = 150
        let lineGap : CGFloat = 5
        let label2Y : CGFloat = gap + labelHeight + lineGap
        
        title = UILabel()
        title.frame = CGRectMake(gap, gap, labelWidth, labelHeight)
        title.textColor = UIColor.blackColor()
        contentView.addSubview(title)
        
        subTitle = UILabel()
        subTitle.frame = CGRectMake(gap, label2Y, labelWidth, labelHeight)
        subTitle.textColor = UIColor.blackColor()
        contentView.addSubview(subTitle)
        
        
}

}