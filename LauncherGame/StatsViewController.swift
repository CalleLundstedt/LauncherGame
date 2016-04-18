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
        
        let statsDict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Statistics",ofType: "plist")!)!
        distanceLabel.text = "\(statsDict["TotalDistance"] as! Int)"
        failureLabel.text = "\(statsDict["NumberOfFails"])"
       

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
