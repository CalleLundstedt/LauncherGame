//
//  MainViewController.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 19/04/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    var mainClass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !checkCurrent() {
            continueButton.alpha = 0.4
            continueButton.enabled = false
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkCurrent() -> Bool {
        
        let charDict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Characters", ofType: "plist")!)!
        
        let classes = charDict["Classes"] as! NSArray
        for i in classes {
            if (i["CurrentLevel"] as! Int) > 0 {
                mainClass = i["Name"]
                return true
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "continueGame" {
            if let destinationViewController = segue.destinationViewController as? DestinationViewController {
                destinationViewController.data = data
            }
        
        }
    }
}