//
//  GameOverScene.swift
//  FlappyGo
//
//  Created by Kenan Atmaca on 31.03.2018.
//  Copyright © 2018 Kenan Atmaca. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var restartButton:SKSpriteNode!
    var menuButton:SKSpriteNode!
    var shareButton:SKSpriteNode!
    var rateButton:SKSpriteNode!
    
    var defaults = UserDefaults.standard
    var sounds:[SKAction] = []
    
    var overTitleNode:SKLabelNode = {
        let label = SKLabelNode(fontNamed: "FlappyBirdy")
        label.text = "Game Over"
        label.fontSize = 100
        label.horizontalAlignmentMode = .center
        label.zPosition = 2
        return label
    }()
    
    var scoreTitleNode:SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Flappy-Bird")
        label.fontSize = 40
        label.numberOfLines = 2
        label.horizontalAlignmentMode = .center
        label.zPosition = 2
        return label
    }()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.color(hex: "#ffbe76")
        sounds = [SKAction.playSoundFileNamed("click", waitForCompletion: false)]
        setupScene()
    }
    
    func setupScene() {
        overTitleNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.3)
        addChild(overTitleNode)
        
        scoreTitleNode.position = CGPoint(x: self.frame.width / 2, y: overTitleNode.position.y - 100)
        scoreTitleNode.text = "Score \(defaults.integer(forKey: "score"))\nBest \(defaults.integer(forKey: "highScore"))"
        addChild(scoreTitleNode)
        
        restartButton = SKSpriteNode(imageNamed: "playbtn")
        restartButton.setScale(0.7)
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartButton.name = "RestartButton"
        addChild(restartButton)
        
        menuButton = SKSpriteNode(imageNamed: "menu")
        menuButton.position = CGPoint(x: self.frame.width / 2 - 100, y: self.frame.height / 2 - 100)
        menuButton.name = "MenuButton"
        addChild(menuButton)
        
        shareButton = SKSpriteNode(imageNamed: "share")
        shareButton.position = CGPoint(x: menuButton.position.x + 100, y: self.frame.height / 2 - 100)
        shareButton.name = "ShareButton"
        addChild(shareButton)
        
        rateButton = SKSpriteNode(imageNamed: "rate")
        rateButton.position = CGPoint(x: shareButton.position.x + 100, y: self.frame.height / 2 - 100)
        rateButton.name = "RateButton"
        addChild(rateButton)
        
        let groundTexture = SKTexture(image: #imageLiteral(resourceName: "groundTexture"))
        
        let sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2.0)
        sprite.position = CGPoint(x: groundTexture.size().width, y: groundTexture.size().height / 3)
        addChild(sprite)
        
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        addChild(ground)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            let locName = atPoint(location).name
            
            guard locName != nil else {
                return
            }
            
            switch(locName) {
            case "RestartButton":
                play(0)
                let gameS = GameScene(size: self.size)
                self.view?.presentScene(gameS)
            case "MenuButton":
                play(0)
                let gameS = MenuScene(size: self.size)
                self.view?.presentScene(gameS)
            case "ShareButton":
                play(0)
            case "RateButton":
                play(0)
            default:
                return
            }
        }
    }
}//

extension GameOverScene {
    func play(_ index:Int) {
        run(sounds[index])
    }
}

