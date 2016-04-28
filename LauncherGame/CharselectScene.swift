//
//  GameScene.swift
//  LauncherGame
//
//  Created by Carl Lundstedt on 28/03/16.
//  Copyright (c) 2016 Carl Lundstedt. All rights reserved.
//

import SpriteKit

class CharselectScene: SKScene {
    
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
        
        moveRight = SKAction.moveBy(CGVectorMake(playableRect.width, 0), duration: 1)
        moveLeft = SKAction.moveBy(CGVectorMake(-playableRect.width, 0), duration: 1)
        
        middleChar = loadChars()![0]
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CharselectScene.swipedRight(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CharselectScene.swipedLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        let cropNode = SKCropNode()
        let maskNode = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: playableRect.size.width, height: playableRect.size.width/3))
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
        
        let charArray = loadChars()
        
        var i: CGFloat = 0
        for char in charArray! {
            if char.unlocked {
                let charNode = SKSpriteNode(imageNamed: char.name)
                charNode.name = char.name
                charNode.position = CGPoint(x: CGRectGetMidX(playableRect)+i, y: 3*playableRect.size.height/4)
                allCharsNode.addChild(charNode)
                i += playableRect.width
            } else {
                let charNode = SKSpriteNode(imageNamed: char.name)
                charNode.alpha = 0.3
                charNode.name = char.name
                charNode.position = CGPoint(x: CGRectGetMidX(playableRect)+i, y: 3*playableRect.size.height/4)
                allCharsNode.addChild(charNode)
                i += playableRect.width

            }
        }
        allCharsNode.zPosition = -1
        cropNode.addChild(allCharsNode)
        addChild(cropNode)
        
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer) {
        if allCharsNode.position.x < 0 && !movingRight {
            movingRight = true
            let falseAction = SKAction.runBlock({self.movingRight = false})
            allCharsNode.runAction(SKAction.sequence([moveRight, falseAction]))
        }
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer) {
        if !movingLeft {
            movingLeft = true
            let falseAction = SKAction.runBlock({self.movingLeft = false})
            allCharsNode.runAction(SKAction.sequence([moveLeft,falseAction]))        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        getMiddle()
       
        nameLabel.text = "Name: \(middleChar.name)"
        massLabel.text = "Mass: \(middleChar.mass)"
        unlockedLabel.text = "Unlocked: \(middleChar.unlocked)"
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