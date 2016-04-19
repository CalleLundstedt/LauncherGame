//
//  MainCharacter.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 05/04/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import Foundation
import SpriteKit


class MainCharacter {
    let name: String
    let mass: CGFloat
    let restitution: CGFloat
    let airResistance: CGFloat
    
    init(name: String, mass: CGFloat, restitution: CGFloat, airResistance: CGFloat) {
        self.name = name
        self.mass = mass
        self.restitution = restitution
        self.airResistance = airResistance
    }
    
    init(dictionary: NSDictionary) {
        self.name = dictionary["Name"] as! String
        self.mass = dictionary["Mass"] as! CGFloat
        self.restitution = dictionary["Restitution"] as! CGFloat
        self.airResistance = dictionary["AirResistance"] as! CGFloat
    }
}

