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
    
    var mainCharName: String = "Newbie"
    var mainCurrentLevel: Int = 0
    var mainChars: [MainCharacter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if loadChars() == nil {
            createData()
        }
     
        continueButton.enabled = false
        mainChars = loadChars()!
        for char in mainChars {
            if char.currentLevel > 1 {
                continueButton.enabled = true
                mainCharName = char.name
                mainCurrentLevel = char.currentLevel
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "continueGame" {
            if let destinationViewController = segue.destinationViewController as? GameViewController {
                destinationViewController.currentClass = mainCharName
                destinationViewController.currentLevel = mainCurrentLevel
            }
        }
    }
    
    @IBAction func startGame(sender: AnyObject) {
        if !continueButton.enabled {
            performSegueWithIdentifier("selectChar", sender: self)
        } else {
            let alert = UIAlertController()
            alert.title = "Discard saved game?"
            alert.message = "You have a saved game, do you want to continue and discard it?"
            let yesButton = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
                _ in
                saveLevel(self.mainCharName, level: 1)
                self.performSegueWithIdentifier("selectChar", sender: self)
            }
            let noButton = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) {
                _ in
                
            }
            
            alert.addAction(yesButton)
            alert.addAction(noButton)
            alert.modalInPopover = true
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func createData() {
        let zeroStats = Statistics(totalPlays: 0, totalDistance: 0, totalFails: 0, maxDistance: 0)
        NSKeyedArchiver.archiveRootObject(zeroStats!, toFile: Statistics.ArchiveURL.path!)
        
        let newbChar = MainCharacter(name: "Newbie", mass: 4, restitution: 0.8, airResistance: 0.3, unlocked: true, currentLevel: 1)
        let fitnessChar = MainCharacter(name: "Fitness", mass: 6, restitution: 0.5, airResistance: 0.2, unlocked: true, currentLevel: 1)
        let bodybuilderChar = MainCharacter(name: "Bodybuilder", mass: 8, restitution: 0.3, airResistance: 0.5, unlocked: true, currentLevel: 1)
        
        let allChars = [newbChar!, fitnessChar!, bodybuilderChar!]
        NSKeyedArchiver.archiveRootObject(allChars, toFile: MainCharacter.ArchiveURL.path!)
        
        var allLevels: [Level] = []
        for i in 1...6 {
            let level = Level(levelNumber: i, distance: 5000*i)
            allLevels.append(level!)
        }
        NSKeyedArchiver.archiveRootObject(allLevels, toFile: Level.ArchiveURL.path!)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }

}