//
//  sdmAppDelegate.swift
//  RadialSlider
//
//  Created by Peter JC Spencer on 23/06/2015.
//  Copyright (c) 2015 Spencer's digital media. All rights reserved.
//

import UIKit

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Property(s)
    
    var window: UIWindow?
    

    // MARK: - UIApplicationDelegate Protocol
    
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
            let controller: RootController = RootController(nibName: nil, bundle: nil)
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            self.window?.backgroundColor = UIColor.whiteColor()
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
            
            return true
    }
}


