//
//  sdmEffectView.swift
//  RadialSlider
//
//  Created by Peter JC Spencer on 29/06/2015.
//  Copyright (c) 2015 Spencer's digital media. All rights reserved.
//

import UIKit


class EffectView : UIView
{
    // MARK: - 
    
    var locked: Bool = false
    private var _ramp: CGFloat = 0.0
    var ramp: CGFloat
    {
        get { return self._ramp }
        set
        {
            if !self.locked
            {
                self._ramp = newValue < 0.0 ? 0.0 : newValue
                self._ramp = newValue > 1.0 ? 1.0 : newValue
                
                if let aLayer = self.layer as? EffectLayer
                { aLayer.offset = newValue }
                
                self.setNeedsDisplay()
            }
        }
    }
    
    var sourceRadius: CGFloat = 100.0
    var destinationRadius: CGFloat = 18.0
    var destinationOffset: CGFloat = 125.0
    
    var srcCentre: CGPoint!
    var srcScale: CGFloat = 0.7
    
    var dstCentre: CGPoint!
    var dstScale: CGFloat = 1.0
    
    var controlOffset: CGPoint!
    
    
    // MARK: - 
    
    override var frame: CGRect {
        
        didSet
        {
            self.srcCentre = CGPointMake(self.bounds.size.width * 0.5,
                self.bounds.size.width * 0.5)
            
            self.dstCentre = CGPointMake(self.srcCentre.x + self.destinationOffset,
                self.srcCentre.y)
        }
    }
    
    
    // MARK: - Initializing a View Object (UIView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
        
        self.srcCentre = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.width * 0.5)
        self.dstCentre = CGPointMake(self.srcCentre.x + self.destinationOffset, self.srcCentre.y)
        self.controlOffset = CGPointMake(20.0, 10.0)
    }
    
    
    // MARK: - NSCoding Protocol
    
    required init(coder decoder: NSCoder) { super.init(coder: decoder) }
    
    
    // MARK: - 
    
    override class func layerClass() -> AnyClass { return EffectLayer.self }

    
    // MARK: -
    
    func setRamp(newValue: CGFloat, animated: Bool)
    {
        if animated
        {
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "offset")
            animation.duration = 0.35
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.7, 0.0, 0.2, 1.0)
            animation.fromValue = self._ramp
            animation.toValue = 0.0
            
            self.layer.addAnimation(animation, forKey: nil)
        }
        else { self._ramp = newValue }
        
        if let aLayer = self.layer as? EffectLayer
        {
            aLayer.offset = 0.0
        }
    }
    
    
    // MARK: -
    
    override func drawRect(rect: CGRect) {
        
        // Super.
        super.drawRect(rect)
        
        let context: CGContextRef  = UIGraphicsGetCurrentContext ()
        CGContextSetFillColorWithColor(context, UIColor.cyanColor().CGColor)
        
        if self.locked && (self._ramp <= 0.0)
        {
            CGContextAddEllipseInRect(context,
                CGRectMake((rect.size.width * 0.5) - (self.sourceRadius * 0.5),
                (rect.size.height * 0.5) - (self.sourceRadius * 0.5),
                self.sourceRadius,
                self.sourceRadius));
            
            CGContextFillPath (context)
            return
        }
        
        let srcRadius: CGFloat = Math.interpLinear(self._ramp, start: self.sourceRadius, end: self.sourceRadius * self.srcScale)
        let dstRadius: CGFloat = Math.interpLinear(self._ramp, start: self.sourceRadius, end: self.destinationRadius * self.dstScale)
        let dstCentreX: CGFloat = Math.interpLinear(self._ramp, start: self.srcCentre.x, end: self.dstCentre.x)
        
        var controlAngle: CGFloat = CGFloat( Math.degreesToRadians( Double(Math.interpLinear(self._ramp, start: 280.0, end: 300.0))) )
        var endAngle: CGFloat = CGFloat( Math.degreesToRadians( Double(Math.interpLinear(self._ramp, start: 290.0, end: 260.0))) )
        
        let xOffset: CGFloat = Math.interpLinear(self._ramp, start: 0.0, end: self.controlOffset.x)
        let yOffset: CGFloat = Math.interpLinear(self._ramp, start: 0.0, end: self.controlOffset.y)
        
        // Top.
        CGContextAddArc(context,
            self.srcCentre.x,
            self.srcCentre.y,
            srcRadius * 0.5,
            CGFloat(Math.degreesToRadians(180.0)),
            controlAngle,
            0)
        
        CGContextAddQuadCurveToPoint(context,
            self.srcCentre.x + cos(controlAngle) * (srcRadius * 0.5) + xOffset,
            self.srcCentre.y + sin(controlAngle) * (srcRadius * 0.5) + yOffset,
            dstCentreX + cos(endAngle) * (dstRadius * 0.5),
            self.dstCentre.y + sin(endAngle) * (dstRadius * 0.5))
        
        CGContextAddArc(context,
            dstCentreX,
            self.dstCentre.y,
            dstRadius * 0.5,
            CGFloat(Math.degreesToRadians(290.0)),
            0.0,
            0)
        
        // Move.
        CGContextMoveToPoint(context, self.srcCentre.x - (srcRadius * 0.5), self.srcCentre.y)
        
        controlAngle = CGFloat( Math.degreesToRadians( Double(Math.interpLinear(self._ramp, start: 80.0, end: 60.0))) )
        endAngle = CGFloat( Math.degreesToRadians( Double(Math.interpLinear(self._ramp, start: 70.0, end: 100.0))) )
        
        // Bottom.
        CGContextAddArc(context,
            self.srcCentre.x,
            self.srcCentre.y,
            srcRadius * 0.5,
            CGFloat(Math.degreesToRadians(180.0)),
            CGFloat(Math.degreesToRadians(Double(Math.interpLinear(self._ramp, start: 80.0, end: 60.0)))),
            1)
        
        CGContextAddQuadCurveToPoint(context,
            self.srcCentre.x + cos(controlAngle) * (srcRadius * 0.5) + xOffset,
            self.srcCentre.y + sin(controlAngle) * (srcRadius * 0.5) - yOffset,
            dstCentreX + cos(endAngle) * (dstRadius * 0.5),
            self.dstCentre.y + sin(endAngle) * (dstRadius * 0.5))
        
        CGContextAddArc(context,
            dstCentreX,
            self.dstCentre.y,
            dstRadius * 0.5,
            CGFloat(Math.degreesToRadians(70.0)),
            0.0,
            1)
        
        CGContextFillPath (context)
    }
    
    override func drawLayer(layer: CALayer!, inContext ctx: CGContext!) {
        
        if let aLayer = layer as? EffectLayer
        {
            self._ramp = aLayer.offset
        }
        
        if self._ramp < 0.0 { self._ramp = 0.0 }
        
        // Super.
        super.drawLayer(layer, inContext: ctx)
    }
}


