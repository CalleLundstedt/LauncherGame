//
//  Level.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 21/04/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

//
//  MainCharacter.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 05/04/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import Foundation

class Level: NSObject, NSCoding {
    
    struct PropertyKey {
        static let numberKey = "levelNumber"
        static let distanceKey = "distance"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("levels")
    
    let levelNumber: Int
    let distance: Int
    
    init?(levelNumber: Int, distance: Int) {
        self.levelNumber = levelNumber
        self.distance = distance
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(levelNumber, forKey: PropertyKey.numberKey)
        aCoder.encodeObject(distance, forKey: PropertyKey.distanceKey)
      
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let levelNumber = aDecoder.decodeObjectForKey(PropertyKey.numberKey) as! Int
        let distance = aDecoder.decodeObjectForKey(PropertyKey.distanceKey) as! Int
        
        self.init(levelNumber: levelNumber, distance: distance)
    }
}

