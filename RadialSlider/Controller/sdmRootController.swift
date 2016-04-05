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
        
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = UIColor.whiteColor()
        
        // NB: Although an interesting thought this isn't an excercise in parsing json.
        if let path = NSBundle.mainBundle().pathForResource("Settings", ofType: "json")
        {
            let data = NSData(contentsOfFile: path)
            
            do {
            
                if let json =  try NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject]
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
                        
                        let radialControl: SegmentedRadialSlider = SegmentedRadialSlider(cells: cells)
                        
                        radialControl.addTarget(self, action: #selector(RootController.valueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
                        radialControl.center = CGPointMake(UIScreen.mainScreen().bounds.size.width * 0.5,
                            UIScreen.mainScreen().bounds.height * 0.5)
                        
                        self.view.addSubview(radialControl)
                    }
                }
            }
            catch let error as NSError { print(error.description) }
        }
    }
    
    
    // MARK: - Utility
    
    func valueChanged(control: SegmentedRadialSlider) {}
}


