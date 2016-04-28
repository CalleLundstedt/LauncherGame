//
//  RandomSpawn.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 27/04/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import Foundation
import SpriteKit

class RandomSpawn: SKSpriteNode {
    
    
    var yBoost: CGFloat
    var xBoost: CGFloat
    
    init(name: String, yBoost: CGFloat, xBoost: CGFloat) {
        let texture = SKTexture(imageNamed: name)
        self.yBoost = yBoost
        self.xBoost = xBoost
        
        super.init(texture: texture, color: UIColor.blackColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func getRandomSpawn() -> RandomSpawn {
    
    let spawn: RandomSpawn
    if arc4random_uniform(3) <= 1 {
        spawn = RandomSpawn(name: "goodie", yBoost: 1000, xBoost: 1000)
    } else {
        spawn = RandomSpawn(name: "baddie", yBoost: -1000, xBoost: -1000)
    }
    return spawn
}