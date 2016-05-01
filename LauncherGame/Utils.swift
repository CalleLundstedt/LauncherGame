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

func randomAlpha() -> CGFloat {
    return CGFloat(Float(arc4random_uniform(10) + 5) / 15.0)
}

func / (left: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: left.x/scalar, y: left.y/scalar)
}

func + (left: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: left.x+scalar, y: left.y+scalar)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x+right.x, y: left.y+right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x-right.x, y: left.y-right.y)
}

func <= (left: CGVector, right: CGVector) -> Bool {
    return (left.dx <= right.dx) && (left.dy <= right.dy)
}

func saveStats(distance: Int, won: Bool) {
    
    let stats = loadStats()!
    
    stats.totalDistance += distance
    stats.totalPlays += 1
    
    if stats.maxDistance < distance {
        stats.maxDistance = distance
    }
    
    if !won {
        stats.totalFails += 1
    }
    
    NSKeyedArchiver.archiveRootObject(stats, toFile: Statistics.ArchiveURL.path!)
}

func loadChars() -> [MainCharacter]? {
    return NSKeyedUnarchiver.unarchiveObjectWithFile(MainCharacter.ArchiveURL.path!) as? [MainCharacter]
}

func loadStats() -> Statistics? {
    return NSKeyedUnarchiver.unarchiveObjectWithFile(Statistics.ArchiveURL.path!) as? Statistics
}

func loadLevels() -> [Level]? {
    return NSKeyedUnarchiver.unarchiveObjectWithFile(Level.ArchiveURL.path!) as? [Level]
}

func saveLevel(name: String, level: Int) {
    let allChars = loadChars()!
    for char in allChars {
        if char.name == name {
            char.currentLevel = level
        }
    }
    NSKeyedArchiver.archiveRootObject(allChars, toFile: MainCharacter.ArchiveURL.path!)
}

func getMain(name: String) -> MainCharacter? {
    let allChars = loadChars()!
    
    for char in allChars {
        if char.name == name {
            return char
        }
    }
    return nil
}

func getLevelDistance(currentLevel: Int) -> Int {
    let allLevels = loadLevels()!
    
    for level in allLevels {
        if level.levelNumber == currentLevel {
            return level.distance
        }
    }
    return 0
}

enum GameState {
    case StartingLevel
    case Started
    case InAir
    case GameOver
    case GameWon
    case GameLost
}


extension CGPoint {
    var angle: CGFloat {
        return atan2(y,x)
    }
}
