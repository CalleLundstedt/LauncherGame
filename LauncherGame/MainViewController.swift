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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !checkCurrent() {
            continueButton.enabled = false
        }
        
        createPlist("Statistics")
        createPlist("Levels")
        createPlist("Characters")
        
        

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
    
    func checkCurrent() -> Bool {
        let characterDict = getDictionary("Characters")
        let characterArray = characterDict["Classes"] as! NSArray
        for character in characterArray {
           let curr = character as! NSDictionary
            if (curr["CurrentLevel"] as! Int) > 0 {
                mainCharName = curr["Name"] as! String
                mainCurrentLevel = curr["CurrentLevel"] as! Int
                return true
            }
        }
        return false
    }
    
    func createPlist(plistName: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("\(plistName).plist")
        let fileManager = NSFileManager.defaultManager()
        
        if(!fileManager.fileExistsAtPath(path)) {
            if let bundlePath = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist") {
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch {
                    print(error)
                }
            }
        }
    }
}

