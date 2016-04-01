//
//  GameScene.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 28/03/16.
//  Copyright (c) 2016 Carl Lundstedt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    let arrow = SKSpriteNode(imageNamed: "arrow")
    let playableRect: CGRect
    var arrowDefaultWidth: CGFloat = 0.0
    var lastUpdateTime: NSTimeInterval = 0.0, dt: NSTimeInterval = 0
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        arrow.anchorPoint = CGPointMake(0,0.5);
        arrow.position = CGPoint(x: CGRectGetMinX(playableRect), y: CGRectGetMinY(playableRect))
        arrowDefaultWidth = arrow.size.width

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        touchStart(touchLocation)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        touchMoved(touchLocation)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchStopped()
    }
   
    override func update(currentTime: CFTimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime

    }
    
    func touchStart(touchPoint: CGPoint) {
        let delta = arrow.position-touchPoint
        var angle = delta.angle + π
        
        if(angle < 0) {
            angle += 2*π
        }
        
        arrow.zRotation = angle
        if(touchPoint.length() < 500) {
            let scale = touchPoint.length()/arrowDefaultWidth
            let scaleAction = SKAction.scaleTo(scale, duration: 0)
            arrow.runAction(scaleAction)
        }
        addChild(arrow)
        
    }
    
    func touchMoved(touchPoint: CGPoint) {
        let delta = arrow.position-touchPoint
        var angle = delta.angle + π
        
        if(angle < 0) {
            angle += 2*π
        }
        
        let rotateAction = SKAction.rotateToAngle(angle, duration: 0)
        arrow.runAction(rotateAction)
        
        if(touchPoint.length() < 500) {
            let scale = touchPoint.length()/arrowDefaultWidth
            print(touchPoint.length())
            let scaleAction = SKAction.scaleTo(scale, duration: 0)
            arrow.runAction(scaleAction)
        }
    }
    
    func touchStopped() {
        arrow.removeFromParent()
    }
}
