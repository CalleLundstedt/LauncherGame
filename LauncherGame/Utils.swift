//
//  Utils.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 28/03/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import Foundation
import CoreGraphics

let π = CGFloat(M_PI)

func shortestAngleBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    let twoπ = π*2
    
    var angle = (angle2-angle1) % twoπ
    if(angle >= π) {
        angle = angle - twoπ
    }
    if(angle <= -π) {
        angle = angle + twoπ
    }
    return angle
}

func getDictionary(name: String) -> NSDictionary {
    return NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource(name, ofType: "plist")!)!
}

func randomAlpha() -> CGFloat {
    return CGFloat(Float(arc4random_uniform(10) + 5) / 15.0)
}

func / (left: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: left.x/scalar, y: left.y/scalar)
}

func + (left: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: left.x+scalar, y: left.y+scalar)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x-right.x, y: left.y-right.y)
}

func <= (left: CGVector, right: CGVector) -> Bool {
    return (left.dx <= right.dx) && (left.dy <= right.dy)
}

func saveToPlist(distance: Int, won: Bool, plist: String) {
    
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
    let documentsDirectory = paths.objectAtIndex(0) as! NSString
    let path = documentsDirectory.stringByAppendingPathComponent("\(plist).plist")
    
    let loadDict = NSDictionary(contentsOfFile: path)
    let saveDict = NSMutableDictionary(contentsOfFile: path)
    
    let newDistance = distance + (loadDict?.objectForKey("TotalDistance") as! Int)
    let newTotalPlays = (loadDict?.objectForKey("TotalPlays") as! Int) + 1
    
    
    saveDict!.setObject(newDistance, forKey: "TotalDistance")
    saveDict!.setObject(newTotalPlays, forKey: "TotalPlays")
    
    saveDict!.writeToFile(path, atomically: false)
    let resultDictionary = NSMutableDictionary(contentsOfFile: path)
    print("Saved GameData.plist file is --> \(resultDictionary?.description)")
}

func loadFromPlist(key: String, plist: String) -> AnyObject {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
    let documentsDirectory = paths.objectAtIndex(0) as! NSString
    let path = documentsDirectory.stringByAppendingPathComponent("\(plist).plist")
    
    let loadDict = NSDictionary(contentsOfFile: path)
    
    return (loadDict?.objectForKey(key))!
}

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
    
    var angle: CGFloat {
        return atan2(y,x)
    }
}
