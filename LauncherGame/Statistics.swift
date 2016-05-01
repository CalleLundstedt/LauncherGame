//
//  Statistics.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 21/04/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import Foundation

class Statistics: NSObject, NSCoding {
    
    struct PropertyKey {
        
        static let totalPlaysKey = "totalPlays"
        static let totalDistanceKey = "totalDistance"
        static let totalFailsKey = "totalFails"
        static let maxDistanceKey = "maxDistance"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("statistics")
    
    var totalPlays: Int
    var totalDistance: Int
    var totalFails: Int
    var maxDistance: Int
    
    init?(totalPlays: Int, totalDistance: Int, totalFails: Int, maxDistance: Int) {
        self.totalPlays = totalPlays
        self.totalDistance = totalDistance
        self.totalFails = totalFails
        self.maxDistance = maxDistance
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(totalPlays, forKey: PropertyKey.totalPlaysKey)
        aCoder.encodeObject(totalDistance, forKey: PropertyKey.totalDistanceKey)
        aCoder.encodeObject(totalFails, forKey: PropertyKey.totalFailsKey)
        aCoder.encodeObject(maxDistance, forKey: PropertyKey.maxDistanceKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let totalPlays = aDecoder.decodeObjectForKey(PropertyKey.totalPlaysKey) as! Int
        let totalDistance = aDecoder.decodeObjectForKey(PropertyKey.totalDistanceKey) as! Int
        let totalFails = aDecoder.decodeObjectForKey(PropertyKey.totalFailsKey) as! Int
        let maxDistance = aDecoder.decodeObjectForKey(PropertyKey.maxDistanceKey) as! Int
        
        self.init(totalPlays: totalPlays, totalDistance: totalDistance, totalFails: totalFails, maxDistance: maxDistance)
    }
}


