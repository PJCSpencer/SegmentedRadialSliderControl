//
//  sdmArcView.swift
//  RadialSlider
//
//  Created by Peter JC Spencer on 26/06/2015.
//  Copyright (c) 2015 Spencer's digital media. All rights reserved.
//

import UIKit


class ArcView : UIView
{
    // MARK: - 
    
    var startAngle: CGFloat = 0.0
    {
        willSet { self.shape.strokeStart = newValue }
    }
    
    var endAngle: CGFloat = 0.3
    {
        willSet { self.shape.strokeEnd = newValue }
    }
    
    var lineWidth: CGFloat = 20.0
    {
        willSet { self.shape.lineWidth = newValue }
    }
    
    
    // MARK: - 
    
    private var _shape: CAShapeLayer?
    private var shape: CAShapeLayer
    {
        // Defaults.
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        let radius: CGFloat = ((width > height ? width : height) * 0.5)
        
        if _shape == nil
        {
            var path:CGMutablePathRef = CGPathCreateMutable()
            CGPathAddArc(path,
                nil,
                width * 0.5,
                height * 0.5,
                radius,
                CGFloat(Math.degreesToRadians(0.0)),
                CGFloat(Math.degreesToRadians(360.0)),
                false)
            
            _shape = CAShapeLayer()
            _shape!.fillColor = UIColor.clearColor().CGColor
            _shape!.strokeColor = UIColor.lightGrayColor().CGColor
            _shape!.lineWidth = self.lineWidth
            _shape!.strokeEnd = self.endAngle
            _shape!.lineCap = kCALineCapRound
            _shape!.path = path
            
            self.layer.addSublayer(_shape)
        }
        return _shape!
    }
    
    
    // MARK: - Initializing a View Object (UIView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
    }
    
    
    // MARK: - NSCoding Protocol
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}


