//
//  MainViewController.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 13/04/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    
    
    
    @IBAction func startTheGame(sender: AnyObject) {
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
}
