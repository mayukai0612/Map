//
//  LIneView.swift
//  Map
//
//  Created by Yukai Ma on 19/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    
//    class func dottedLine(radius radius: CGFloat, space: CGFloat, numberOfPattern: CGFloat) -> UIImage {
//        
//        
//        let path = UIBezierPath()
//        path.moveToPoint(CGPointMake(radius/2, radius/2))
//        path.addLineToPoint(CGPointMake((numberOfPattern)*(space+1)*radius, radius/2))
//        path.lineWidth = radius
//        
//        let dashes: [CGFloat] = [path.lineWidth * 0, path.lineWidth * (space+1)]
//        path.setLineDash(dashes, count: dashes.count, phase: 0)
//        path.lineCapStyle = CGLineCap.Round
//        
//        
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake((numberOfPattern)*(space+1)*radius, radius), false, 1)
//        UIColor.whiteColor().setStroke()
//        path.stroke()
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return image
//        
//    }
    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
//        
//        let context = UIGraphicsGetCurrentContext()
//        CGContextSetLineWidth(context, 2.0)
//        CGContextSetStrokeColorWithColor(context, UIColor.greenColor().CGColor)
//        CGContextMoveToPoint(context, self.bounds.origin.x, self.bounds.origin.y)
//        CGContextAddLineToPoint(context,  400, self.bounds.origin.y)
//        CGContextStrokePath(context)
//        
//        
//    }
    
    func addDashedLine(color: UIColor = UIColor.lightGrayColor()) {
        layer.sublayers?.filter({ $0.name == "DashedTopLine" }).map({ $0.removeFromSuperlayer() })
        self.backgroundColor = UIColor.clearColor()
        let cgColor = color.CGColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [4, 4]
        
        let path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        print("width")
        print(self.frame.width)
        CGPathAddLineToPoint(path, nil, 400, 0)
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
    

}
