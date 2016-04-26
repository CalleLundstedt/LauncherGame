//
//  MainCharacter.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 05/04/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import Foundation
import SpriteKit


class MainCharacter: NSObject, NSCoding {
    
    struct PropertyKey {
        static let nameKey = "name"
        static let massKey = "mass"
        static let restitutionKey = "restitution"
        static let airRestistanceKey = "airResistance"
        static let currentLevelKey = "currentLevel"
        static let unlockedKey = "unlocked"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("characters")
    
    let name: String
    let mass: CGFloat
    let restitution: CGFloat
    let airResistance: CGFloat
    var currentLevel: Int
    var unlocked: Bool
    
    init?(name: String, mass: CGFloat, restitution: CGFloat, airResistance: CGFloat, unlocked: Bool, currentLevel: Int) {
        self.name = name
        self.mass = mass
        self.restitution = restitution
        self.airResistance = airResistance
        self.unlocked = unlocked
        self.currentLevel = currentLevel
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(mass, forKey: PropertyKey.massKey)
        aCoder.encodeObject(restitution, forKey: PropertyKey.restitutionKey)
        aCoder.encodeObject(airResistance, forKey: PropertyKey.airRestistanceKey)
        aCoder.encodeInteger(currentLevel, forKey: PropertyKey.currentLevelKey)
        aCoder.encodeBool(unlocked, forKey: PropertyKey.unlockedKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let mass = aDecoder.decodeObjectForKey(PropertyKey.massKey) as! CGFloat
        let restitution = aDecoder.decodeObjectForKey(PropertyKey.restitutionKey) as! CGFloat
        let airResistance = aDecoder.decodeObjectForKey(PropertyKey.airRestistanceKey) as! CGFloat
        let currentLevel = aDecoder.decodeIntegerForKey(PropertyKey.currentLevelKey)
        let unlocked  = aDecoder.decodeBoolForKey(PropertyKey.unlockedKey)
        
        self.init(name: name, mass: mass, restitution: restitution, airResistance: airResistance, unlocked: unlocked, currentLevel: currentLevel)
    }
}

