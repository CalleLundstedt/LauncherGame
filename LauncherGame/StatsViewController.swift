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
    @IBOutlet weak var maxDistanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 99/255, blue: 53/255, alpha: 1)
        
        
        let stats = loadStats()
        
        distanceLabel.text = "\(stats!.totalDistance)"
        failureLabel.text = "\(stats!.totalFails)"
        maxDistanceLabel.text = "\(stats!.maxDistance)"
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func loadStats() -> Statistics? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Statistics.ArchiveURL.path!) as? Statistics
    }
}
