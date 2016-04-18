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

func saveToPlist(distance: Int, won: Bool) {
    
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
