//
//  sdmRootController.swift
//  RadialSlider
//
//  Created by Peter JC Spencer on 23/06/2015.
//  Copyright (c) 2015 Spencer's digital media. All rights reserved.
//

import UIKit


class RootController: UIViewController {
    
    // MARK: - Managing the View (UIViewController)
    
    override func loadView() {
        
        var root: UIView = UIView(frame: UIScreen.mainScreen().bounds)
        root.backgroundColor = UIColor.whiteColor()
        self.view = root;
        
        // Although an interesting thought this isn't an excercise in parsing json.
        var error: NSError?
        if let data : NSData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("Settings", ofType: "json")!,
            options: .DataReadingUncached,
            error: &error)
        {
            if let json = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.MutableContainers,
                error: &error) as? [String:AnyObject]
            {
                if let items = json["items"] as? [AnyObject]
                {
                    var cell: SegmentedRadialSliderCell!
                    var cells: [SegmentedRadialSliderCell] = []
                    
                    for config in items
                    {
                        cell = SegmentedRadialSliderCell(frame: CGRectMake(0.0, 0.0, 70.0, 70.0))
                        
                        cell.title = config["title"] as? String
                        cell.presentationAngle = config["presentation-angle"] as! CGFloat
                        
                        cells.append(cell)
                    }
                    
                    var radialControl: SegmentedRadialSlider = SegmentedRadialSlider(cells: cells)
                    
                    radialControl.center = CGPointMake(UIScreen.mainScreen().bounds.size.width * 0.5,
                        UIScreen.mainScreen().bounds.height * 0.5)
                    radialControl.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                    
                    root.addSubview(radialControl)
                }
            }
        }
    }
    
    
    // MARK: - 
    
    func valueChanged(control: SegmentedRadialSlider) {}
}


