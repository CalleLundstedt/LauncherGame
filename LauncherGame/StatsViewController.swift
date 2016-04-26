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
        
        let stats = loadStats()
        
        distanceLabel.text = "\(stats!.totalDistance)"
        failureLabel.text = "\(stats!.totalFails)"
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func loadStats() -> Statistics? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Statistics.ArchiveURL.path!) as? Statistics
    }
}
