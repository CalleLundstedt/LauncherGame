//
//  GameScene.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 28/03/16.
//  Copyright (c) 2016 Carl Lundstedt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var currentLevel: Int
    var distanceToWin:Int = 1000
    
    let arrow = SKSpriteNode(imageNamed: "arrow")
    var groundLayer = SKSpriteNode()
    var backgroundLayer = SKSpriteNode()
    var houseLayer = SKSpriteNode()
    let cameraNode:SKCameraNode = SKCameraNode()
    var distanceLabel: UILabel
    var mainCharNode:SKSpriteNode
    
    var cameraPositionX: CGFloat = 0
    
    let weaponPower: CGFloat
    var mainChar:MainCharacter
    var playableRect: CGRect
    var lastUpdateTime: NSTimeInterval = 0.0, dt: NSTimeInterval = 0
    var inAir: Bool = false, gameOver: Bool = false, pastMid: Bool = false
    var distance: Int
    var mainCharStartingPoint: CGFloat = 0
    
    var rangeToMain: SKRange
    let yRange: SKRange
    
    let yConstraint: SKConstraint, distanceConstraint: SKConstraint
    
    init(size: CGSize, label: UILabel, level: Int) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        let main = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Characters", ofType: "plist")!)!
        let mainClass = main["Classes"] as! NSArray
        mainChar = MainCharacter(dictionary: mainClass[0] as! NSDictionary)
        mainCharNode = SKSpriteNode(imageNamed: mainChar.name)
        yRange = SKRange(constantValue: CGRectGetMidY(playableRect)-250)
        rangeToMain = SKRange(constantValue: 0)
        distanceConstraint = SKConstraint.distance(rangeToMain, toNode: mainCharNode)
        yConstraint = SKConstraint.positionY(yRange)
        
        currentLevel = level
        distance = 0
        distanceLabel = label
        
        weaponPower = 1000
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        
        print("hej")
        let config = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Levels",ofType: "plist")!)!
        let levels = config["Levels"] as! [[String:AnyObject]]
        if currentLevel >= levels.count {
            currentLevel = 0
        }
        distanceToWin = (levels[currentLevel]["Distance"] as? Int)!
        
        backgroundColor = SKColor.init(red: 75/255, green: 185/255, blue: 1, alpha: 1)
        
        self.physicsWorld.gravity = CGVectorMake(0, -6)
        self.physicsBody = physicsBody
        
        mainCharNode.position = CGPoint(x: CGRectGetMinX(playableRect)+mainCharNode.size.width,
            y: CGRectGetMinY(playableRect)+mainCharNode.size.height/2)
        mainCharNode.zPosition = 11
        mainCharStartingPoint = mainCharNode.position.x
        addChild(mainCharNode)
        
        groundLayer = createGround()
        groundLayer.anchorPoint = CGPoint(x: 0, y: 0)
        groundLayer.position = CGPoint(x: 0, y: CGRectGetMinX(playableRect))
        addChild(groundLayer)
        
        houseLayer = createHouses()
        addChild(houseLayer)
        
        rangeToMain = SKRange(constantValue: mainCharNode.position.x)
        
        backgroundLayer.zPosition = -1
        backgroundLayer.position = CGPoint(x:0,y:0)
        addChild(backgroundLayer)
        
        cameraNode.position = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect)-mainCharNode.size.height)
        self.camera = cameraNode
        addChild(cameraNode)
        cameraNode.constraints = [yConstraint]
        cameraPositionX = cameraNode.position.x
        
        arrow.anchorPoint = CGPointMake(0,0.5)
        arrow.zPosition = 10
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
        
        if mainCharNode.position.x > CGRectGetMidX(playableRect) && !pastMid {
            pastMid = true
            cameraNode.constraints!.append(distanceConstraint)
        }
        
        if pastMid {
            createClouds()
        }
        
        if(inAir && !gameOver) {
            distance = Int(mainCharNode.position.x - mainCharStartingPoint)
            if(mainCharNode.physicsBody!.velocity <= CGVector(dx: 30, dy: 10) && mainCharNode.position.y <= 320) {
                gameOver = true
                mainCharNode.physicsBody!.dynamic = false
                print("Game over! Distance: \(distance)")
            }
            if distance >= distanceToWin {
                distanceLabel.text = "\(distance)"
                let newScene = GameScene(size:size, label: distanceLabel, level: currentLevel+1)
                view!.presentScene(newScene, transition: SKTransition.flipVerticalWithDuration(0.5))
            }
        }
        distanceLabel.text = "\(distance)"
        scrollBackground()
    }
    

    
    func touchStart(touchPoint: CGPoint) {
        if !inAir {
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
    }
    
    
    func touchMoved(touchPoint: CGPoint) {
        if !inAir {
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
    }
    
    func touchStopped(touchPoint: CGPoint) {
        
        if !inAir {
            inAir = true
            
            let angle = arrow.zRotation
            let startingVelocity = CGVectorMake((π/2-angle)*weaponPower, angle*weaponPower)
            arrow.removeFromParent()
        
            mainCharNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: mainChar.name), size: mainCharNode.size)
            mainCharNode.physicsBody?.mass = mainChar.mass
            mainCharNode.physicsBody?.restitution = mainChar.restitution
            mainCharNode.physicsBody?.linearDamping = mainChar.airResistance
            mainCharNode.physicsBody?.velocity = startingVelocity
        } else {
            mainCharNode.physicsBody?.applyImpulse(CGVectorMake(1000, 1000))
        }
    }
    
    func createClouds() {
        if arc4random_uniform(1000) <= 40 {
            let cloud = SKSpriteNode(imageNamed: "cloud")
            cloud.name = "cloud"
            cloud.alpha = randomAlpha()
            cloud.position.x = mainCharNode.position.x + playableRect.size.width + cloud.size.width
            cloud.position.y = CGFloat(arc4random_uniform(UInt32(playableRect.size.height)) + UInt32(playableRect.size.height))
            backgroundLayer.addChild(cloud)
        }
    }
    
    func createGround() -> SKSpriteNode {
        let groundLayer = SKSpriteNode()
        for i in 0...7 {
            let ground = SKSpriteNode(imageNamed: "ground")
            ground.position = CGPoint(x: CGRectGetMinX(playableRect)+CGFloat(i)*ground.size.width, y: CGRectGetMinY(playableRect)-ground.size.height)
            ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.frame.size, center: CGPoint(x: ground.size.width/2, y: ground.size.height/2))
            ground.physicsBody?.dynamic = false
            ground.zPosition = 9
            ground.anchorPoint = CGPoint(x: 0, y: 0)
            ground.name = "ground"
            groundLayer.addChild(ground)
        }
        return groundLayer
    }
    
    func createHouses() -> SKSpriteNode {
        let houseLayer = SKSpriteNode()
        for i in 0...3 {
            let house = SKSpriteNode(imageNamed: "houses")
            house.anchorPoint = CGPoint(x: 1, y: 1)
            house.position = CGPoint(x: CGRectGetMinX(playableRect)+CGFloat(i)*house.size.width,
                                     y: CGRectGetMinY(playableRect)+house.size.height)
            house.zPosition = 9
            house.name = "house"
            houseLayer.addChild(house)
        }
        return houseLayer
    }
    
    func scrollBackground() {
        groundLayer.enumerateChildNodesWithName("ground") {
            node, _ in
            let ground = node as! SKSpriteNode
            if ground.position.x < self.mainCharNode.position.x-self.playableRect.width {
                ground.position.x += 7*ground.size.width
            }
        }
        
        houseLayer.enumerateChildNodesWithName("house") {
            node, _ in
            let house = node as! SKSpriteNode
            if house.position.x < self.mainCharNode.position.x-self.playableRect.width {
                house.position.x += 3*house.size.width
            }
        }
    }
}
