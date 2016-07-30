//
//  RectangleLayer.swift
//  I'm..
//
//  Created by Skylar Thomas on 7/8/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class RectangleLayer: CAShapeLayer {
    
    override init() {
        super.init()
        fillColor = UIColor.clearColor().CGColor
        lineWidth = 10.0
        path = rectanglePathFull.CGPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rectanglePathFull: UIBezierPath {
        let rectanglePath = UIBezierPath()
        //rectanglePath.moveToPoint(CGPoint(x: 0.0, y: 100.0))
        rectanglePath.moveToPoint(CGPointMake(screenSize.width*0.5, screenSize.height * (160/568))) //start pt
        rectanglePath.addLineToPoint(CGPointMake(screenSize.width*0.5, screenSize.height*(90/568)))
        rectanglePath.addLineToPoint(CGPointMake(screenSize.width*0.5, screenSize.height*(100/568)))
        //rectanglePath.applyTransform(CGAffineTransformMakeScale(2, 2))
//        rectanglePath.addLineToPoint(CGPoint(x: 0.0, y: -lineWidth))
//        rectanglePath.addLineToPoint(CGPoint(x: 100.0, y: -lineWidth))
//        rectanglePath.addLineToPoint(CGPoint(x: 100.0, y: 100.0))
//        rectanglePath.addLineToPoint(CGPoint(x: -lineWidth / 2, y: 100.0))
        //rectanglePath.closePath()
        return rectanglePath
    }
    
    func animateStrokeWithColor(color: UIColor) {
        strokeColor = color.CGColor
        let strokeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.duration = 0.1
        addAnimation(strokeAnimation, forKey: nil)
    }


}
