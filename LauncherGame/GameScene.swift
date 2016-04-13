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
    
    var backgroundLayer = SKSpriteNode()
    
    var cameraPositionX: CGFloat = 0
    
    let weaponPower: CGFloat
    var mainCharNode:SKSpriteNode
    var mainChar:MainCharacter
    var playableRect: CGRect
    var lastUpdateTime: NSTimeInterval = 0.0, dt: NSTimeInterval = 0
    var inAir: Bool = false, gameOver: Bool = false, pastMid: Bool = false
    var distance: CGFloat = 0.0
    let rangeToMain = SKRange(constantValue: 0)
    let yRange = SKRange(constantValue: 768.0)
    let yConstraint: SKConstraint, distanceConstraint: SKConstraint

    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        mainChar = MainCharacter(name: "guy", mass: 5, restitution: 0.8, airResistance: 0.2)
        mainCharNode = SKSpriteNode(imageNamed: mainChar.name)
        distanceConstraint = SKConstraint.distance(rangeToMain, toNode: mainCharNode)
        yConstraint = SKConstraint.positionY(yRange)
        weaponPower = 1000
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.init(red: 75/255, green: 185/255, blue: 1, alpha: 1)
        
        self.physicsWorld.gravity = CGVectorMake(0, -6)
        self.physicsBody = physicsBody
        self.physicsBody?.categoryBitMask = worldCategory
        
        mainCharNode.position = CGPoint(x: CGRectGetMinX(playableRect)+mainCharNode.size.width,
            y: CGRectGetMinY(playableRect)+mainCharNode.size.height*2)
        mainCharNode.zPosition = 10
        addChild(mainCharNode)
        
        ground.position = CGPoint(x: CGRectGetMinX(playableRect)+playableRect.size.width/2,
            y: CGRectGetMinY(playableRect))
        ground.size.width = 60000
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.frame.size)
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.dynamic = false
        ground.zPosition = 9
        addChild(ground)
        
        backgroundLayer.zPosition = -1
        backgroundLayer.position = CGPoint(x:0,y:0)
        addChild(backgroundLayer)
        
        
        cameraNode.setScale(2)
        cameraNode.position = CGPoint(x: CGRectGetMaxX(playableRect), y: CGRectGetMidY(playableRect))
        self.camera = cameraNode
        addChild(cameraNode)
        cameraPositionX = cameraNode.position.x
        
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
        
        
        
        if mainCharNode.position.x > CGRectGetMaxX(playableRect) && !pastMid {
            pastMid = true
            cameraNode.constraints = [distanceConstraint]
        }
        
        if(inAir && !gameOver) {
            distance += (mainCharNode.physicsBody?.velocity.dx)!*CGFloat(dt)
            createClouds()
            if(mainCharNode.physicsBody!.velocity <= CGVector(dx: 30, dy: 10) && mainCharNode.position.y <= 100) {
                gameOver = true
                mainCharNode.physicsBody!.dynamic = false
                print("Game over! Distance: \(distance)")
            }
        }
        
        if cameraPositionX < cameraNode.position.x {
            cameraPositionX = cameraNode.position.x
            moveBackground(cameraNode.position.x - cameraPositionX)
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
    }
    
    func touchStopped(touchPoint: CGPoint) {
        
        if !inAir {
            let angle = arrow.zRotation
            let startingVelocity = CGVectorMake((π/2-angle)*weaponPower, angle*weaponPower)
            
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
    
    func createClouds() {
        if arc4random_uniform(1000) <= 20 {
            let cloud = SKSpriteNode(imageNamed: "cloud")
            cloud.name = "cloud"
            cloud.alpha = randomAlpha()
            cloud.position.x = mainCharNode.position.x + 2000
            cloud.position.y = CGFloat(arc4random_uniform(1080) + 200)
            backgroundLayer.addChild(cloud)
        }
    }
    
    func moveBackground(moved: CGFloat) {
        backgroundLayer.enumerateChildNodesWithName("cloud") {
            node, _ in
            node.position.x += moved
        }
    
    }
}
