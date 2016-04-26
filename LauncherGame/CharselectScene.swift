//
//  GameScene.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 28/03/16.
//  Copyright (c) 2016 Carl Lundstedt. All rights reserved.
//

import SpriteKit

class CharselectScene: SKScene {
    
    let rightArrow = SKSpriteNode(imageNamed: "rightarrow")
    let leftArrow = SKSpriteNode(imageNamed: "rightarrow")
    let allCharsNode = SKSpriteNode()
    let moveRight: SKAction, moveLeft: SKAction
    
    var nameLabel = SKLabelNode()
    var massLabel = SKLabelNode()
    var infoLabel = SKLabelNode()
    var unlockedLabel = SKLabelNode()
    var movingRight = false
    var movingLeft = false
    var middleChar: MainCharacter
    
    var playableRect: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let playableMargin = (size.width-playableWidth)/2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        
        moveRight = SKAction.moveBy(CGVectorMake(playableRect.width/2, 0), duration: 1)
        moveLeft = SKAction.moveBy(CGVectorMake(-playableRect.width/2, 0), duration: 1)
        
        middleChar = loadChars()![0]
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        let cropNode = SKCropNode()
        let maskNode = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: playableRect.size.width/3, height: playableRect.size.width/3))
        maskNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        maskNode.position = CGPoint(x: CGRectGetMidX(playableRect),y: 3*playableRect.size.height/4)
        cropNode.maskNode = maskNode
        
        
        nameLabel.position = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect))
        nameLabel.fontSize = 100
        addChild(nameLabel)
        
        massLabel.position = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect)-playableRect.size.height/20)
        massLabel.fontSize = 100
        addChild(massLabel)
        
        unlockedLabel.position = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect)-playableRect.size.height/10)
        unlockedLabel.fontSize = 100
        addChild(unlockedLabel)
        
        
        rightArrow.position = CGPoint(x: playableRect.width, y: 3*playableRect.size.height/4)
        addChild(rightArrow)

        leftArrow.zRotation = π
        leftArrow.anchorPoint = CGPoint(x: 0, y: 0.5)
        leftArrow.position = CGPoint(x: CGRectGetMinX(playableRect)+leftArrow.size.width, y: 3*playableRect.size.height/4)
        addChild(leftArrow)
        
        let charArray = loadChars()
        
        var i: CGFloat = 0
        for char in charArray! {
            if char.unlocked {
                let charNode = SKSpriteNode(imageNamed: char.name)
                charNode.name = char.name
                charNode.position = CGPoint(x: CGRectGetMidX(playableRect)+i, y: 3*playableRect.size.height/4)
                allCharsNode.addChild(charNode)
                i += playableRect.width/2
            } else {
                let charNode = SKSpriteNode(imageNamed: char.name)
                charNode.alpha = 0.3
                charNode.name = char.name
                charNode.position = CGPoint(x: CGRectGetMidX(playableRect)+i, y: 3*playableRect.size.height/4)
                allCharsNode.addChild(charNode)
                i += playableRect.width/2

            }
        }
        allCharsNode.zPosition = -1
        cropNode.addChild(allCharsNode)
        addChild(cropNode)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        getMiddle()
       
        nameLabel.text = "Name: \(middleChar.name)"
        massLabel.text = "Mass: \(middleChar.mass)"
        unlockedLabel.text = "Unlocked: \(middleChar.unlocked)"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        
        if rightArrow.containsPoint(touchLocation) && allCharsNode.position.x < 0 && !movingRight {
            movingRight = true
            let falseAction = SKAction.runBlock({self.movingRight = false})
            allCharsNode.runAction(SKAction.sequence([moveRight, falseAction]))
        }
        
        if leftArrow.containsPoint(touchLocation) && !movingLeft {
            movingLeft = true
            let falseAction = SKAction.runBlock({self.movingLeft = false})
            allCharsNode.runAction(SKAction.sequence([moveLeft,falseAction]))
        }
        
    }
    
    func getMiddle() {
        for child in allCharsNode.children {
            let currChild = child as! SKSpriteNode
            if round(currChild.position.x+allCharsNode.position.x) == CGRectGetMidX(playableRect){
                
                for char in loadChars()! {
                    if char.name == currChild.name {
                        middleChar = char
                    }
                }
                
            }
        }
    }
}