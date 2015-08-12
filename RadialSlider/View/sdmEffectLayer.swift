//
//  sdmEffectLayer.swift
//  RadialSlider
//
//  Created by Peter JC Spencer on 29/06/2015.
//  Copyright (c) 2015 Spencer's digital media. All rights reserved.
//

import UIKit



class EffectLayer : CAShapeLayer
{
    // MARK: - Property(s)
    
    @NSManaged var offset: CGFloat
    
    
    // MARK: - 
    
    override init!() {
        super.init()
    }
    
    override init!(layer: AnyObject!) {
        
        // Super.
        super.init(layer: layer)
        
        if layer.isKindOfClass(EffectLayer.self)
        {
            if let aLayer = layer as? EffectLayer
            {
                self.offset = aLayer.offset
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: -
    
    override func actionForKey(key: String!) -> CAAction! {
        
        if key == "offset"
        {
            let animation: CABasicAnimation = CABasicAnimation(keyPath: key)
            
            animation.duration = 0.3
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.7, 0.0, 0.2, 1.0)
            animation.fromValue = self.presentationLayer().valueForKey(key)
            
            return animation
        }
        
        // Super.
        return super.actionForKey(key)
    }
    
    
    // MARK: -
    
    override class func needsDisplayForKey(key: String!) -> Bool {
    
        if key == "offset"
        {
            return true
        }
        
        // Super.
        return super.needsDisplayForKey(key)
    }
}



