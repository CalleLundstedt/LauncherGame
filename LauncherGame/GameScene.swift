//
//  GameScene.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 28/03/16.
//  Copyright (c) 2016 Carl Lundstedt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let mainCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let groundCategory: UInt32 = 1 << 2
    let arrow = SKSpriteNode(imageNamed: "arrow")
    let ground = SKSpriteNode(imageNamed: "ground")
    let cameraNode:SKCameraNode = SKCameraNode()
    var mainCharNode:SKSpriteNode
    var hiddenMainNode: SKSpriteNode
    var mainChar:MainCharacter
    var playableRect: CGRect
    var lastUpdateTime: NSTimeInterval = 0.0, dt: NSTimeInterval = 0
    var inAir: Bool = false, gameOver: Bool = false
    var distance: CGFloat = 0.0
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        mainChar = MainCharacter(name: "guy", mass: 5, restitution: 0.8, airResistance: 0.2)
        mainCharNode = SKSpriteNode(imageNamed: mainChar.name)
        hiddenMainNode = SKSpriteNode(imageNamed: "\(mainChar.name) copy")
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.gravity = CGVectorMake(0, -6)
        self.physicsBody = physicsBody
        self.physicsBody?.categoryBitMask = worldCategory
        
        
        mainCharNode.position = CGPoint(x: CGRectGetMinX(playableRect)+mainCharNode.size.width,
            y: CGRectGetMinY(playableRect)+mainCharNode.size.height*2)
        addChild(mainCharNode)
        
        hiddenMainNode.position = mainCharNode.position
        hiddenMainNode.hidden = true
        addChild(hiddenMainNode)
        
        ground.position = CGPoint(x: CGRectGetMinX(playableRect)+playableRect.size.width/2,
            y: CGRectGetMinY(playableRect))
        ground.size.width = 60000
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.frame.size)
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.dynamic = false
        addChild(ground)
        
        
        cameraNode.setScale(2)
        cameraNode.position = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMinY(playableRect))
        self.camera = cameraNode
        addChild(cameraNode)
        
        arrow.anchorPoint = CGPointMake(0,0.5)
        arrow.position = mainCharNode.position
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        if !inAir {
            touchStart(touchLocation)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        if !inAir {
            touchMoved(touchLocation)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        touchStopped(touchLocation)
    }
   
    override func update(currentTime: CFTimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        if mainCharNode.position.x > 1000 {
            let moveCamera = SKAction.moveTo(CGPoint(x: mainCharNode.position.x+(mainCharNode.physicsBody!.velocity.dx*CGFloat(dt)), y: cameraNode.position.y), duration: dt)
            self.camera?.runAction(moveCamera)
        }
        
        if(inAir && !gameOver) {
            distance += (mainCharNode.physicsBody?.velocity.dx)!*CGFloat(dt)
            if(mainCharNode.physicsBody?.velocity == CGVector(dx: 0,dy: 0)) {
                gameOver = true
                mainCharNode.physicsBody?.dynamic = false
                print(distance)
            }
        }

    }
    
    func touchStart(touchPoint: CGPoint) {
            let delta = arrow.position-touchPoint
            var angle = delta.angle + π
        
            if(angle < 0) {
                angle += 2*π
            }
        
            arrow.zRotation = angle
            addChild(arrow)
    }
    
    func touchMoved(touchPoint: CGPoint) {
        let delta = arrow.position-touchPoint
        var angle = delta.angle + π
        
        if(angle < 0) {
            angle += 2*π
        }
        
        if(angle <= π/2) {
            let rotateAction = SKAction.rotateToAngle(angle, duration: 0)
            arrow.runAction(rotateAction)
        }

    }
    
    func touchStopped(touchPoint: CGPoint) {
        if !inAir {
            arrow.removeFromParent()
            inAir = true
        
            mainCharNode.physicsBody = SKPhysicsBody(circleOfRadius: mainCharNode.size.width/2)
            mainCharNode.physicsBody?.mass = mainChar.mass
            mainCharNode.physicsBody?.restitution = mainChar.restitution
            mainCharNode.physicsBody?.linearDamping = mainChar.airResistance
            mainCharNode.physicsBody?.velocity = CGVectorMake(touchPoint.x*2, touchPoint.y*2)
            mainCharNode.physicsBody?.categoryBitMask = mainCategory
            mainCharNode.physicsBody?.collisionBitMask = groundCategory
        } else {
            mainCharNode.physicsBody?.applyImpulse(CGVectorMake(100, 100))
        }
    }
}
