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
    let power: CGFloat
    var mainCharNode:SKSpriteNode
    var mainChar:MainCharacter
    var playableRect: CGRect
    var lastUpdateTime: NSTimeInterval = 0.0, dt: NSTimeInterval = 0
    var inAir: Bool = false, gameOver: Bool = false, pastMid: Bool = false
    var distance: CGFloat = 0.0
    let rangeToMain = SKRange(constantValue: 0)
    let distanceConstraint:SKConstraint, yConstraint: SKConstraint

    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        mainChar = MainCharacter(name: "guy", mass: 5, restitution: 0.8, airResistance: 0.2)
        mainCharNode = SKSpriteNode(imageNamed: mainChar.name)
        distanceConstraint = SKConstraint.distance(self.rangeToMain, toNode: mainCharNode)
        yConstraint = SKConstraint.positionY(SKRange(constantValue: 0))
        power = 1000
        
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
        
        ground.position = CGPoint(x: CGRectGetMinX(playableRect)+playableRect.size.width/2,
            y: CGRectGetMinY(playableRect))
        ground.size.width = 60000
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.frame.size)
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.dynamic = false
        addChild(ground)
        
        
        cameraNode.setScale(2)
        cameraNode.position = CGPoint(x: playableRect.size.width, y: CGRectGetMidY(playableRect))
        self.camera = cameraNode
        cameraNode.constraints = [yConstraint]
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
        
        if mainCharNode.position.x > 1000 && !pastMid {
            pastMid = true
            cameraNode.constraints?.append(distanceConstraint)
        }
        
        if(inAir && !gameOver) {
                distance += (mainCharNode.physicsBody?.velocity.dx)!*CGFloat(dt)
                if(mainCharNode.physicsBody!.velocity <= CGVector(dx: 30,dy: 10) && (mainCharNode.position.y <= 100)) {
                    gameOver = true
                    mainCharNode.physicsBody?.dynamic = false
                    print("Gameover! Distance: \(distance)")
                }
            }
    }
    

    
    func touchStart(touchPoint: CGPoint) {
        let delta = arrow.position-touchPoint
        var angle = delta.angle + π
        
        if angle<0 {
            angle += 2*π
        }
        
        if angle > π/2 && angle < π {
            angle = π/2
        } else if angle > π {
            angle = 0
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
        print(arrow.zRotation)
    }
    
    func touchStopped(touchPoint: CGPoint) {
        
        if !inAir {
            let angle = arrow.zRotation
            let startingVelocity = CGVectorMake((π/2-angle)*power, angle*power)
            
            arrow.removeFromParent()
            inAir = true
        
            mainCharNode.physicsBody = SKPhysicsBody(circleOfRadius: mainCharNode.size.width/2)
            mainCharNode.physicsBody?.mass = mainChar.mass
            mainCharNode.physicsBody?.restitution = mainChar.restitution
            mainCharNode.physicsBody?.linearDamping = mainChar.airResistance
            mainCharNode.physicsBody?.velocity = startingVelocity
            mainCharNode.physicsBody?.categoryBitMask = mainCategory
            mainCharNode.physicsBody?.collisionBitMask = groundCategory
        } else {
            mainCharNode.physicsBody?.applyImpulse(CGVectorMake(1000, 1000))
        }
    }
}
