//
//  CharselectViewController.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 20/04/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import UIKit
import SpriteKit

class CharselectViewController: UIViewController {

    @IBOutlet weak var chooseButton: UIButton!
    let scene = CharselectScene(size: CGSize(width: 1536, height: 2048))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startGame" {
            if let destinationViewController = segue.destinationViewController as? GameViewController {
                destinationViewController.currentClass = scene.middleChar.name
                destinationViewController.currentLevel = scene.middleChar.currentLevel
            }
        }
        
    }
}
