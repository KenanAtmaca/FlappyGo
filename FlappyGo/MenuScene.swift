//
//  MenuScene.swift
//  FlappyGo
//
//  Created by Kenan Atmaca on 31.03.2018.
//  Copyright © 2018 Kenan Atmaca. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
        
    var playButton:SKSpriteNode!
    var rateButton:SKSpriteNode!
    var shareButton:SKSpriteNode!
    var noAdsButton:SKSpriteNode!

    var sounds:[SKAction] = []
    
    var menuTitleNode:SKLabelNode = {
        let label = SKLabelNode(fontNamed: "FlappyBirdy")
        label.fontSize = 100
        label.text = "Flappy Go"
        label.horizontalAlignmentMode = .center
        label.zPosition = 2
        return label
    }()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.color(hex: "#74b9ff")
        sounds = [SKAction.playSoundFileNamed("click", waitForCompletion: false)]
        setupScene()
    }
    
    func setupScene() {
        menuTitleNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.3)
        addChild(menuTitleNode)
        
        let playBtnTexture = SKTexture(image: #imageLiteral(resourceName: "playbtn"))
        playBtnTexture.filteringMode = .nearest
        
        playButton = SKSpriteNode(texture: playBtnTexture)
        playButton.name = "PlayButton"
        playButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        addChild(playButton)
        
        shareButton = SKSpriteNode(imageNamed: "share")
        shareButton.name = "ShareButton"
        shareButton.position = CGPoint(x: self.frame.width / 2 - 100, y: playButton.position.y - 130)
        addChild(shareButton)
        
        rateButton = SKSpriteNode(imageNamed: "rate")
        rateButton.name = "RateButton"
        rateButton.position = CGPoint(x: self.frame.width / 2 + 100, y: playButton.position.y - 130)
        addChild(rateButton)
        
        noAdsButton = SKSpriteNode(imageNamed: "noads")
        noAdsButton.setScale(0.5)
        noAdsButton.name = "RemoveAds"
        noAdsButton.position = CGPoint(x: self.frame.width / 2, y: playButton.position.y - 130)
        addChild(noAdsButton)
        
        let birdTexture = SKTexture(imageNamed: "bird-01")
        birdTexture.filteringMode = .nearest
        
        let bird = SKSpriteNode(texture: birdTexture)
        bird.setScale(1.5)
        bird.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 1.5)
        addChild(bird)

        let birdTexture1 = SKTexture(imageNamed: "bird-01")
        birdTexture1.filteringMode = .nearest
        let birdTexture2 = SKTexture(imageNamed: "bird-02")
        birdTexture2.filteringMode = .nearest
        let birdTexture3 = SKTexture(imageNamed: "bird-03")
        birdTexture2.filteringMode = .nearest
        let birdTexture4 = SKTexture(imageNamed: "bird-04")
        birdTexture2.filteringMode = .nearest

        let anim = SKAction.animate(with: [birdTexture1, birdTexture2,birdTexture3,birdTexture4], timePerFrame: 0.2)
        let flap = SKAction.repeatForever(anim)

        bird.run(flap)
        
        let groundTexture = SKTexture(image: #imageLiteral(resourceName: "groundTexture"))
        
        let sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2.0)
        sprite.position = CGPoint(x: groundTexture.size().width, y: groundTexture.size().height / 3)
        addChild(sprite)
        
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        addChild(ground)
        
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .nearest
        
        let skyNode = SKSpriteNode(texture: skyTexture)
        skyNode.setScale(2.0)
        skyNode.position = CGPoint(x: skyTexture.size().width, y: self.frame.height / 3.2)
        skyNode.zPosition = -1
        addChild(skyNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let locName = atPoint(location).name
            
            guard locName != nil else {
                return
            }
            
            switch(locName) {
            case "PlayButton":
                play(0)
                let gameS = GameScene(size: self.size)
                self.view?.presentScene(gameS)
            case "RateButton":
                play(0)
            case "ShareButton":
                play(0)
            case "RemoveAds":
                play(0)
            default:
                return
            }
        }
    }
}//

extension MenuScene {
    func play(_ index:Int) {
       run(sounds[index])
    }
}

