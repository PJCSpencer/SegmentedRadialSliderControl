//
//  sdmSegmentedRadialSliderCell.swift
//  RadialSlider
//
//  Created by Peter JC Spencer on 24/06/2015.
//  Copyright (c) 2015 Spencer's digital media. All rights reserved.
//

import UIKit


class SegmentedRadialSliderCell : UIView
{
    // MARK: - Property(s)
    
    final private(set) var value: Float = 25.0
    final func updateValue(newValue: Float)
    {
        if newValue >= self.minimumValue && newValue <= self.maximumValue
        {
            self.value = newValue
        }
    }
    var minimumValue: Float = 0.0
    var maximumValue: Float = 50.0
    
    final private var _titleLabel: UILabel?
    final private var titleLabel: UILabel
    {
        if _titleLabel == nil
        {
            _titleLabel = UILabel(frame: CGRectZero)
            _titleLabel!.textAlignment = NSTextAlignment.Center
            _titleLabel!.font = UIFont.boldSystemFontOfSize(15.0)
            
            self.addSubview(_titleLabel!)
        }
        return _titleLabel!
    }
    
    final var title: String?
    {
        get { return self.titleLabel.text }
        set(newTitle)
        {
            self.titleLabel.text = newTitle
            self.titleLabel.hidden = (self.titleLabel.text == nil ? true : false)
        }
    }
    
    final private var backgroundImageView: UIImageView
    {
        struct Static { static var instance: UIImageView? }
        if Static.instance == nil
        {
            Static.instance = UIImageView(frame: self.bounds)
            Static.instance?.contentMode = UIViewContentMode.ScaleAspectFit
                
            self.addSubview(Static.instance!)
        }
        return Static.instance!
    }
    
    final var backgroundImage: UIImage?
    {
        get { return self.backgroundImageView.image }
        set(newBackgroundImage)
        {
            self.backgroundImageView.image = newBackgroundImage
            self.backgroundImageView.hidden = (self.backgroundImageView.image == nil ? false : true)
        }
    }
    
    final var arcLength: CGFloat = 0.3
    final var presentationAngle: CGFloat = 0.0
    final var trackingPath: CGPathRef?
    private var trackingPathLayer: CAShapeLayer?
    
    
    // MARK: - 
    
    final func addTrackingPath(trackingRect: CGRect, radius: CGFloat, start: CGFloat, end: CGFloat)
    {
        let path:CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, trackingRect.size.width * 0.5, trackingRect.size.height * 0.5)
        CGPathAddArc(path,
            nil,
            trackingRect.size.width * 0.5,
            trackingRect.size.height * 0.5,
            radius,
            start,
            end,
            false)
        CGPathAddLineToPoint(path, nil, trackingRect.size.width * 0.5, trackingRect.size.height * 0.5)
        
        self.trackingPath = path
    }
    
    
    // MARK: - Initializing a View Object (UIView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let radius: CGFloat = (frame.size.width > frame.size.height ? frame.size.width : frame.size.height)
        
        self.backgroundColor = UIColor.greenColor()
        self.userInteractionEnabled = false
        self.layer.cornerRadius = radius * CGFloat(0.5)
    }
    
    
    // MARK: - NSCoding Protocol
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    // MARK: - Laying out Subviews (UIView)
    
    override func layoutSubviews() {
        
        // Super.
        super.layoutSubviews()
        
        let labelHeight: CGFloat = 20.0
        let scale: CGFloat = 0.5
        
        self.titleLabel.frame = CGRectMake(0.0,
            (self.bounds.size.height * CGFloat(scale)) - (labelHeight * CGFloat(scale)),
            self.bounds.size.width,
            labelHeight)
    }
}


