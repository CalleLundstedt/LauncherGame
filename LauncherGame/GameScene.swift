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
    var gymNode = SKSpriteNode()
    let cameraNode:SKCameraNode = SKCameraNode()
    var distanceLabel: UILabel
    var mainCharNode:SKSpriteNode
    var gameState: GameState
    
    var cameraPositionX: CGFloat = 0
    
    let weaponPower: CGFloat
    let mainChar: MainCharacter
    var currentChar: String
    var playableRect: CGRect
    var lastUpdateTime: NSTimeInterval = 0.0, dt: NSTimeInterval = 0
    var inAir: Bool = false, gameOver: Bool = false, pastMid: Bool = false
    var distance: Int
    var mainCharStartingPoint: CGFloat = 0
    var numberOfLifts: Int = 100
    
    var rangeToMain: SKRange
    let distanceConstraint: SKConstraint
    
    init(size: CGSize, label: UILabel, level: Int, character: String) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        mainCharNode = SKSpriteNode(imageNamed: character)
        mainChar = getMain(character)!
        
        rangeToMain = SKRange(constantValue: 0)
        distanceConstraint = SKConstraint.distance(rangeToMain, toNode: mainCharNode)
        currentChar = character
        
        currentLevel = level
        distance = 0
        distanceLabel = label
        distanceLabel.text = "\(distance)"
        gameState = GameState.StartingLevel
        
        weaponPower = 1000
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        
        distanceToWin = getLevelDistance(currentLevel)
        backgroundColor = SKColor.init(red: 75/255, green: 185/255, blue: 1, alpha: 1)
        
        self.physicsWorld.gravity = CGVectorMake(0, -5)
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
        
        backgroundLayer.zPosition = -1
        backgroundLayer.position = CGPoint(x:0,y:0)
        addChild(backgroundLayer)
        
        cameraNode.position = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMinY(playableRect) + mainCharNode.size.height)
        self.camera = cameraNode
        addChild(cameraNode)
        cameraPositionX = cameraNode.position.x
        
        gymNode = SKSpriteNode(imageNamed: "gym")
        gymNode.size.height = gymNode.size.height*2
        gymNode.size.width = gymNode.size.width*2
        gymNode.position = CGPoint(x: CGFloat(distanceToWin)+gymNode.size.width, y: CGRectGetMinY(playableRect)+gymNode.size.height/2)
        gymNode.zPosition = 10
        addChild(gymNode)
        
        
        arrow.anchorPoint = CGPointMake(0,0.5)
        arrow.zPosition = 10
        arrow.position = mainCharNode.position
        
        startMessage()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        if gameState == GameState.Started {
             touchStart(touchLocation)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        if gameState != GameState.InAir {
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
            cameraNode.constraints = [distanceConstraint]
        }
        
        if pastMid {
            createClouds()
        }
        
        if(gameState == GameState.InAir) {
            distance = Int(mainCharNode.position.x - mainCharStartingPoint)
            distanceLabel.text = "\(distance)"
            if(mainCharNode.physicsBody!.velocity <= CGVector(dx: 30, dy: 10) && mainCharNode.position.y <= 320) {
                gameState = .GameOver
                endGame(false)
            }
            if distance >= distanceToWin  {
                gameState = .GameOver
                endGame(true)
            }
        }
        scrollBackground()
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
        
        switch gameState {
        case .StartingLevel:
            childNodeWithName("startBackground")!.hidden = true
            gameState = .Started
            
        case .Started:
            let angle = arrow.zRotation
            let startingVelocity = CGVectorMake((π/2-angle)*weaponPower, angle*weaponPower)
            arrow.removeFromParent()
            
            mainCharNode.physicsBody = SKPhysicsBody(circleOfRadius: mainCharNode.size.width/2)
            mainCharNode.physicsBody?.mass = mainChar.mass
            mainCharNode.physicsBody?.restitution = mainChar.restitution
            mainCharNode.physicsBody?.linearDamping = mainChar.airResistance
            mainCharNode.physicsBody?.angularDamping = 0.9
            mainCharNode.physicsBody?.velocity = startingVelocity
            gameState = .InAir

        case .InAir:
            if numberOfLifts > 0 {
                numberOfLifts -= 1
                mainCharNode.physicsBody?.applyImpulse(CGVectorMake(1000, 1000))
            }
        default:
            break
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
            ground.size.height = ground.size.height*2
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
    
    func nextScene() -> Void {
        let newScene = GameScene(size:size, label: distanceLabel, level: currentLevel+1, character: currentChar)
        newScene.scaleMode = .AspectFill
        
        view!.presentScene(newScene, transition: SKTransition.flipVerticalWithDuration(0.5))
    }
    
    func changeLevel() {
        let newScene = GameScene(size: size, label: distanceLabel, level: currentLevel+1, character: currentChar)
        newScene.scaleMode = scaleMode
        
        view!.presentScene(newScene)
    }
    
    func startMessage() {
        let background = SKSpriteNode(imageNamed: "infobox")
        background.size = CGSize(width: 3*playableRect.width/4, height: 3*playableRect.height/4)
        background.position = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect)-200)
        background.name = "startBackground"
        background.zPosition = 99
        
        let startLabel1 = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        let startLabel2 = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        let startLabel3 = SKLabelNode()
        
        startLabel1.fontSize = 150
        startLabel1.position = CGPoint(x: 0, y: 200)
        startLabel1.text = "Level: \(currentLevel)"
        startLabel1.zPosition = 100
        
        startLabel2.fontSize = 150
        startLabel2.position = CGPoint(x: 0, y: 0)
        startLabel2.text = "Distance: \(distanceToWin)"
        startLabel2.zPosition = 10
        
        startLabel3.fontSize = 120
        startLabel3.position = CGPoint(x: 0, y: -400)
        startLabel3.text = "Tap screen to start!"
        startLabel3.zPosition = 100

        background.addChild(startLabel1)
        background.addChild(startLabel2)
        background.addChild(startLabel3)
        addChild(background)

    }
    
    func endGame(won: Bool) {
        gameOver = true
        mainCharNode.physicsBody?.dynamic = false
        saveStats(distance, won: won)
        
        let background = SKSpriteNode(imageNamed: "infobox")
        background.size = CGSize(width: 3*playableRect.width/4, height: 3*playableRect.height/4)
        background.position = CGPoint(x: CGRectGetMidX(playableRect), y: -playableRect.height)
        background.zPosition = 99
        
        let endLabel1 = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        let endLabel2 = SKLabelNode()
        
        endLabel1.fontSize = 150
        endLabel2.fontSize = 120
        
        if won {
            distanceLabel.text = "\(distanceToWin)"
            saveLevel(mainChar.name, level: currentLevel+1)
            
            endLabel1.text = "You won!"
            endLabel2.text = "Touch anywhere to start next level"
            
            
           
            
            
            
            let moveToGym = SKAction.moveTo(gymNode.position, duration: 0.3)
            let hideMain = SKAction.runBlock({self.mainCharNode.hidden = true})
            let wait = SKAction.waitForDuration(2)
            let newSceneAction = SKAction.runBlock(changeLevel)
            mainCharNode.runAction(SKAction.sequence([moveToGym,hideMain,wait,newSceneAction]))
        }
    }

}
