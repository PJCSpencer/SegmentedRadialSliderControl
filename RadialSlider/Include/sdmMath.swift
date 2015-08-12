//
//  sdmMath.swift
//  RadialSlider
//
//  Created by Peter JC Spencer on 24/06/2015.
//  Copyright (c) 2015 Spencer's digital media. All rights reserved.
//

import UIKit


final class Math
{
    class func degreesToRadians(value: Double) -> Double
    {
        return value / 180.0 * M_PI
    }
    
    class func radiansToDegrees(value: Double) -> Double
    {
        return value * (180.0 / M_PI)
    }
    
    class func interpLinear(time: CGFloat, start: CGFloat, end: CGFloat) -> CGFloat
    {
        return start + time * (end - start)
    }
    
    class func dot(pt0: CGPoint, pt1: CGPoint) -> Double
    {
        return Double(pt0.x * pt1.x + pt0.y * pt1.y)
    }
}


