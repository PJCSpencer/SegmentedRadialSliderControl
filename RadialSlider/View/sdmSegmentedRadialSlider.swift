//
//  sdmSegmentedRadialSlider.swift
//  RadialSlider
//
//  Created by Peter JC Spencer on 23/06/2015.
//  Copyright (c) 2015 Spencer's digital media. All rights reserved.
//

import UIKit


class SegmentedRadialSlider : UIControl
{
    // MARK: - Property(s)
    
    private var _cellsView: UIView?
    private var cellsView: UIView
    {
        if _cellsView == nil
        {
            self._cellsView = UIView(frame: self.bounds)
            
            self._cellsView?.contentMode = UIViewContentMode.ScaleAspectFit
            self._cellsView?.backgroundColor = UIColor.clearColor()
            self._cellsView?.userInteractionEnabled = false
            
            self.addSubview(self._cellsView!)
        }
        return _cellsView!
    }
    
    private var trackingLayer: CAShapeLayer?
    private var thumbView: UIView?
    private var backgroundView: ArcView?
    private var effectView: EffectView?
    
    var selectedCellIndex: Int = -1
    var selectedCell: SegmentedRadialSliderCell?
    
    final private var touchRadius: CGFloat = 100.0
    final private var requiredLockDistance: CGFloat = 120.0
    final private var lockEnabled: Bool = false
    
    final private var sectorLockAngle: CGFloat = CGFloat(Math.degreesToRadians(360.0 * 0.5))
    final private var offsetLockAngle: CGFloat = 0.0
    
    final private var staticLockAngle: CGFloat = 0.0
    final private var variableLockAngle: CGFloat = 0.0
    
    final private var staticPoint: CGPoint!
    final private var variablePoint: CGPoint!
    
    
    // MARK: - Initializing a SegmentedRadialControl Object
    
    init(cells: [SegmentedRadialSliderCell])
    {
        super.init(frame: CGRectMake(0.0, 0.0, self.touchRadius, self.touchRadius))
        
        let loc: CGFloat = self.requiredLockDistance * 0.5
        
        for object in cells
        {
            object.tag = self.cellsView.subviews.count
            object.alpha = 0.0
            object.center = CGPointMake(loc, loc)
            
            self.cellsView.addSubview(object)
        }
        self.layer.cornerRadius = self.touchRadius * 0.5
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    // MARK: - Initializing a View Object (UIView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = self.touchRadius * 0.5
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    // MARK: - NSCoding Protocol
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    
    // MARK: - 
    
    final func cellWithTag() -> SegmentedRadialSliderCell?
    {
        var cell: SegmentedRadialSliderCell?
        
        // TODO: 
        
        
        return cell
    }
    
    
    // MARK: - Laying out Subviews (UIView)
    
    override func layoutSubviews() {
      
        // Super.
        super.layoutSubviews()
        
        let lineWith: CGFloat = 20.0
        let radius: CGFloat = self.requiredLockDistance * 2.0
        let pt: CGPoint = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5)
        
        var rect: CGRect = CGRectMake(0.0, 0.0, radius, radius)
        
        if self.trackingLayer == nil
        {
            self.trackingLayer = CAShapeLayer()
            self.trackingLayer!.frame = rect
            self.trackingLayer!.fillColor = UIColor.clearColor().CGColor
        }
        
        if self.backgroundView == nil
        {
            self.backgroundView = ArcView(frame: rect)
            self.backgroundView!.center = pt
            self.backgroundView!.lineWidth = lineWith
            self.backgroundView!.alpha = 0.0

            self.backgroundView!.layer.addSublayer(self.trackingLayer!)
            
            self.addSubview(self.backgroundView!)
        }
        
        if self.thumbView == nil
        {
            rect = CGRectMake(0.0, 0.0, radius + lineWith, radius + lineWith)
            
            var path:CGMutablePathRef = CGPathCreateMutable()
            CGPathAddEllipseInRect(path,
                nil,
                CGRectMake(rect.size.width - lineWith, (rect.size.height * 0.5) - (lineWith * 0.5), lineWith, lineWith))
            
            var shape: CAShapeLayer = CAShapeLayer()
            shape.fillColor = UIColor.cyanColor().CGColor
            shape.strokeColor = UIColor.clearColor().CGColor
            shape.path = path
            
            self.thumbView = UIView(frame: rect)
            self.thumbView!.center = pt
            self.thumbView!.userInteractionEnabled = false
            self.thumbView!.backgroundColor = UIColor.clearColor()
            self.thumbView!.alpha = 0.0
            self.thumbView!.layer.addSublayer(shape)
            
            self.addSubview(self.thumbView!)
        }
        
        if self.effectView == nil
        {
            self.effectView = EffectView(frame: rect)
            self.effectView!.center = pt
            
            self.addSubview(self.effectView!)
        }
    }
    
    
    // MARK: - Tracking Touches and Redrawing Controls (UIControl)
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        
        if self.cellsView.subviews.count > 0
        {
            var angle: CGFloat!
            var radius: CGFloat = CGFloat(self.requiredLockDistance * 1.1) // Offset a little.
            let margin: Double = 24.0
            let segment: CGFloat = CGFloat(Math.degreesToRadians(360.0 / Double(self.cellsView.subviews.count) - margin)) * 0.3
            var delay: NSTimeInterval = 0.0
            let centre: CGPoint = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
            
            for object in self.cellsView.subviews as! [SegmentedRadialSliderCell]
            {
                angle = CGFloat( Math.degreesToRadians(Double(object.presentationAngle)) )
                object.center = centre
                object.addTrackingPath(CGRectInset(self.bounds, -5, -5),
                    radius: radius,
                    start: angle - segment,
                    end: angle + segment)
                
                UIView.animateWithDuration(0.3,
                    delay: delay,
                    usingSpringWithDamping: 0.4,
                    initialSpringVelocity: 0.9,
                    options: UIViewAnimationOptions.BeginFromCurrentState,
                    animations:
                    {
                        object.alpha = 1.0
                        object.center = CGPointMake(centre.x + cos(angle) * self.requiredLockDistance,
                            centre.y + sin(angle) * self.requiredLockDistance)
                    },
                    completion:nil)
                
                delay += 0.05 // TODO: Support auto-incrementing ...
            }
        }
        
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        
        let scale: CGFloat = 0.5
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        
        var segment: Int = -1
        
        // Previous.
        let ppt: CGPoint = touch.previousLocationInView(self)
        let pptCentre: CGPoint = CGPointMake(ppt.x - (width * scale), ppt.y - (height * scale))
        let pptAtan: CGFloat = atan2 (pptCentre.y, pptCentre.x)
        let pptPoint: CGPoint = CGPointMake(cos(pptAtan), sin(pptAtan))
        
        // Current.
        let cpt: CGPoint = touch.locationInView(self)
        let cptCentre: CGPoint = CGPointMake(cpt.x - (width * scale), cpt.y - (height * scale))
        let cptAtan: CGFloat = atan2 (cptCentre.y, cptCentre.x)
        let cptPoint: CGPoint = CGPointMake(cos(cptAtan), sin(cptAtan))
        
        let len: CGFloat = sqrt(cptCentre.x * cptCentre.x + cptCentre.y * cptCentre.y)
        
        /* Drag should become visible from outer-edge of perimeter and spring
        back before the limit is achieved. */
        
        let springVally: CGFloat = 0.0
        let springRadius: CGFloat = self.requiredLockDistance * scale + springVally
        
        if len > springRadius && !self.lockEnabled
        {
            self.effectView!.layer.transform = CATransform3DMakeRotation(cptAtan, 0, 0, 1)
            
            let ptRadius: CGPoint = CGPointMake((width * scale) + cos(cptAtan) * springRadius,
                (height * scale) + sin(cptAtan) * springRadius)
            
            let dx: CGFloat = cpt.x - ptRadius.x
            let dy: CGFloat = cpt.y - ptRadius.y
            let distance: CGFloat = sqrt(dx * dx + dy * dy)
            let offset: CGFloat = self.requiredLockDistance - springRadius
            var slope: CGFloat = 1.0 / offset * distance
            slope = (slope > 1.0 ? 1.0 : slope)
            
            self.effectView!.ramp = slope
            
            // Fade out cell(s), find segment index.
            for object in self.cellsView.subviews as! [SegmentedRadialSliderCell]
            {
                object.alpha = 1.0 - slope
                
                if segment == -1 && CGPathContainsPoint(object.trackingPath,
                    nil,
                    touch.locationInView(self),
                    false)
                { segment = object.tag }
            }
            
            if segment == -1 && slope >= 0.5
            {
                self.sendActionsForControlEvents(UIControlEvents.TouchCancel)
                self.endTrackingWithTouch(touch, withEvent: event)
                
                return false
            }
        }
        else if len <= springRadius
        {
            self.effectView!.locked = false
        }
        
        
        // Segment is locked!
        if len >= springRadius && self.lockEnabled
        {
            if CGPathContainsPoint(self.trackingLayer!.path,
                nil,
                touch.locationInView(self.backgroundView!),
                false)
            {
                var det: Double = Double(pptPoint.x * cptPoint.y - pptPoint.y * cptPoint.x)
                var arc: Double = Double(atan2(det, Math.dot(pptPoint, pt1: cptPoint)))
                
                // Generate vector.
                self.variableLockAngle = cptAtan
                self.variablePoint = CGPointMake(cos(self.variableLockAngle), sin(self.variableLockAngle))
                
                // Modify context.
                det = Double(self.staticPoint.x * self.variablePoint.y - self.staticPoint.y * self.variablePoint.x)
                arc = atan2(det, Math.dot(self.staticPoint, pt1: self.variablePoint))
                arc = (arc < 0.05 ? 0.0 : arc)
                arc = (arc > Double(self.sectorLockAngle - 0.05) ? Double(self.sectorLockAngle) : arc)
                
                // println("\(self.sectorLockAngle), \(CGFloat(arc))")
                
                
                
                // arc < 0                  ==  variableLockAngle = sin/cos (angle.low)
                // arc > sectorLockAngle    ==  variableLockAngle = sin/cos (angle.high)
                
                
                
                // Update GUI.
                self.thumbView!.layer.transform = CATransform3DMakeRotation(self.variableLockAngle, 0, 0, 1)
                
                let interpolated: Float = Float(Math.interpLinear(1.0 / self.sectorLockAngle * CGFloat(arc),
                    start: CGFloat(self.selectedCell!.minimumValue),
                    end: CGFloat(self.selectedCell!.maximumValue)))
                
                // Update cell value.
                self.selectedCell!.updateValue(interpolated)
                
                // Send events.
                self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
            }
        }
        
        else if len >= self.requiredLockDistance && !self.lockEnabled && segment != -1
        {
            self.effectView!.setRamp(0.0, animated: true)
            self.effectView!.locked = true
            
            self.lockEnabled = true
            self.selectedCellIndex = segment
            self.selectedCell = self.cellsView.subviews[self.selectedCellIndex] as? SegmentedRadialSliderCell
            
            self.sectorLockAngle = CGFloat(Math.degreesToRadians(360.0 * Double(self.selectedCell!.arcLength)))
            
            self.offsetLockAngle = 1.0 / (CGFloat(self.selectedCell!.maximumValue) - CGFloat(self.selectedCell!.minimumValue)) * CGFloat(self.selectedCell!.value)
            self.staticLockAngle = cptAtan - (self.sectorLockAngle * self.offsetLockAngle)
            self.variableLockAngle = cptAtan
            self.staticPoint = CGPointMake(CGFloat(cos(self.staticLockAngle)), CGFloat(sin(self.staticLockAngle)))
            
            
            // Transform thumb and background views.
            self.thumbView!.layer.transform = CATransform3DMakeRotation(self.variableLockAngle, 0, 0, 1)
            self.backgroundView!.layer.transform = CATransform3DMakeRotation(self.staticLockAngle, 0, 0, 1)
            self.backgroundView!.endAngle = self.selectedCell!.arcLength
            
            
            // Contruct tracking path.
            var path:CGMutablePathRef = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, self.backgroundView!.bounds.size.width * 0.5, self.backgroundView!.bounds.size.height * 0.5)
            CGPathAddArc(path,
                nil,
                self.backgroundView!.bounds.size.width * 0.5,
                self.backgroundView!.bounds.size.height * 0.5,
                self.requiredLockDistance * 10.0,
                0.0,
                CGFloat(Math.degreesToRadians(360.0 * Double(self.selectedCell!.arcLength))),
                false)
            CGPathAddLineToPoint(path, nil, self.backgroundView!.bounds.size.width * 0.5, self.backgroundView!.bounds.size.height * 0.5)
            self.trackingLayer!.path = path
            
            
            // Animate.
            UIView.animateWithDuration(0.3,
                animations:
                {
                    self.thumbView!.alpha = 1.0
                    self.backgroundView!.alpha = 1.0
            })
        }
            
        else if len <= springRadius
        {
            self.lockEnabled = false
            self.selectedCellIndex = -1
            self.selectedCell = nil
            
            self.thumbView!.alpha = 0.0
            self.backgroundView!.alpha = 0.0
            
            for object in self.cellsView.subviews as! [SegmentedRadialSliderCell]
            {
                UIView.animateWithDuration(0.3, animations:{ object.alpha = 1.0 })
            }
        }
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {

        self.lockEnabled = false
        self.selectedCellIndex = -1
        self.selectedCell = nil
        
        self.thumbView!.alpha = 0.0
        self.backgroundView!.alpha = 0.0
        
        self.effectView!.setRamp(0.0, animated: true)
        
        for object in self.cellsView.subviews as! [SegmentedRadialSliderCell]
        {
            UIView.animateWithDuration(0.3, animations:{ object.alpha = 0.0 })
        }
    }
}


