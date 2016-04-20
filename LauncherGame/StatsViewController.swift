//
//  StatsViewController.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 18/04/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var failureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceLabel.text = "\(loadFromPlist("TotalDistance", plist: "Statistics") as! Int)"
        failureLabel.text = "\(loadFromPlist("TotalPlays", plist: "Statistics") as! Int)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
