//
//  GameScene.swift
//  FlappyGo
//
//  Created by Kenan Atmaca on 31.03.2018.
//  Copyright © 2018 Kenan Atmaca. All rights reserved.
//

import SpriteKit
import GameplayKit

enum collision: UInt32 {
    case bird = 1
    case pipes = 2
    case coin = 3
    case ground = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
   
    var bird: SKSpriteNode?
    var pipePair:SKNode!
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    
    var pipesMoveAndRemove = SKAction()
    var spawnAction = SKAction()
    var sounds:[SKAction] = []
    
    var tapTutorialNode:SKSpriteNode!
    var score:Int = 0
    var gameStartFlag:Bool = false
    var speedPoint:CGFloat = 0.01 / 1.6
    var speedDuration:Double = 1.2
    var degreeChangeFlag:Bool = false
    var pipeGap:UInt32 = 130
    
    var scoreLabel:SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Flappy-Bird")
        label.fontSize = 66
        label.text = "0"
        label.horizontalAlignmentMode = .center
        label.fontColor = UIColor.white
        label.zPosition = 2
        return label
    }()

    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = UIColor.color(hex: "#74b9ff")
        
        sounds = [
        SKAction.playSoundFileNamed("sfx_wing", waitForCompletion: false),
        SKAction.playSoundFileNamed("sfx_point", waitForCompletion: false),
        SKAction.playSoundFileNamed("sfx_hit", waitForCompletion: false)
        ]
    
        setupTextures()

        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.3)
        addChild(scoreLabel)
        
        tapTutorialNode = SKSpriteNode(imageNamed: "taptap")
        tapTutorialNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        addChild(tapTutorialNode)
    }
    
    func setupTextures() {
        let birdTexture = SKTexture(image: #imageLiteral(resourceName: "birdTexture"))
        birdTexture.filteringMode = .nearest

        bird = SKSpriteNode(texture: birdTexture)
        bird?.setScale(1.1)
        bird?.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 1.5)

        bird?.physicsBody = SKPhysicsBody(circleOfRadius: (bird?.size.width)! / 2)
        bird?.physicsBody?.linearDamping = 1.1
        bird?.physicsBody?.restitution = 0.0
        bird?.physicsBody?.isDynamic = true
        bird?.physicsBody?.allowsRotation = false
        bird?.physicsBody?.affectedByGravity = false
        bird?.physicsBody?.categoryBitMask = collision.bird.rawValue
        bird?.physicsBody?.contactTestBitMask = collision.pipes.rawValue | collision.coin.rawValue | collision.ground.rawValue
        addChild(bird!)
        
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
        
        bird?.run(flap)
        
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .nearest
        
        let skyNode = SKSpriteNode(texture: skyTexture)
        skyNode.setScale(2.0)
        skyNode.position = CGPoint(x: skyTexture.size().width, y: self.frame.height / 3.2)
        skyNode.zPosition = -99
        addChild(skyNode)
        
        let moveSkySprite = SKAction.moveBy(x: -skyTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveBy(x: skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
        
        let groundTexture = SKTexture(image: #imageLiteral(resourceName: "groundTexture"))
   
        for i in 0 ..< 2 + Int(self.frame.size.width / ( skyTexture.size().width * 2 )) {
            let i = CGFloat(i)
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.run(moveSkySpritesForever)
        }
        
        let sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2.0)
        sprite.position = CGPoint(x: groundTexture.size().width, y: groundTexture.size().height / 3)
        addChild(sprite)
        
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: groundTexture.size().height / 1.5))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = collision.ground.rawValue
        ground.physicsBody?.contactTestBitMask = collision.bird.rawValue
        addChild(ground)
        
        pipeUpTexture = SKTexture(image: #imageLiteral(resourceName: "pipeUp"))
        pipeDownTexture = SKTexture(image: #imageLiteral(resourceName: "pipeDown"))
    }
    
    func startGame() {
        let distanceMove = CGFloat(self.frame.size.width + 2.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveBy(x: -distanceMove, y: 0, duration: TimeInterval(speedPoint * distanceMove))
        let delayRemove = SKAction.fadeOut(withDuration: 0.1)
        let removePipes = SKAction.removeFromParent()

        pipesMoveAndRemove = SKAction.sequence([movePipes,delayRemove,removePipes])

        let spawn = SKAction.run {
            self.spawnPipes()
        }
        
        let delay = SKAction.wait(forDuration: speedDuration)
        let spawnAndDelay = SKAction.sequence([spawn,delay])
        spawnAction = SKAction.repeatForever(spawnAndDelay)
        
        self.run(spawnAction, withKey: "spawnAction")
    }
 
    func degreeChange() {
        switch(score) {
        case 0...5: pipeGap = 130
        case 5...20: pipeGap = 120
        case 20...40: pipeGap = 115
        case 40...60: pipeGap = 112
        case 60...100: pipeGap = 110
        case 100...Int.max: pipeGap = 107
        default:
            return
        }
    }
    
    func spawnPipes() {
        pipePair = SKNode()
        pipePair.position = CGPoint(x: self.frame.size.width + pipeUpTexture.size().width * 2, y: 0)
        pipePair.zPosition = -10
        
        let height = UInt32(self.frame.size.height / 4)
        let y = arc4random() % height + height
        
        let pipedown = SKSpriteNode(texture: pipeDownTexture)
        pipedown.setScale(1.6)
        pipedown.position = CGPoint(x: 0, y: CGFloat(y) + pipedown.size.height)
        pipedown.physicsBody = SKPhysicsBody(rectangleOf: pipedown.size)
        pipedown.physicsBody?.isDynamic = false
        pipedown.physicsBody?.categoryBitMask = collision.pipes.rawValue
        pipedown.physicsBody?.contactTestBitMask = collision.bird.rawValue
        
        pipePair.addChild(pipedown)
        
        let pipeup = SKSpriteNode(texture: pipeUpTexture)
        pipeup.setScale(1.6)
        pipeup.position = CGPoint(x: 0, y: CGFloat(y - self.pipeGap)) // 150 - 107
        pipeup.physicsBody = SKPhysicsBody(rectangleOf: pipeup.size)
        pipeup.physicsBody?.isDynamic = false
        pipeup.physicsBody?.categoryBitMask = collision.pipes.rawValue
        pipeup.physicsBody?.contactTestBitMask = collision.bird.rawValue
       
        pipePair.addChild(pipeup)
        
        let pipeCoin = SKSpriteNode(color: UIColor.clear, size: CGSize.init(width: 32, height: 140))
        pipeCoin.position = CGPoint(x: 0, y: CGFloat(y + 180))
        pipeCoin.physicsBody = SKPhysicsBody(rectangleOf: pipeCoin.size)
        pipeCoin.physicsBody?.isDynamic = false
        pipeCoin.physicsBody?.categoryBitMask = collision.coin.rawValue
        pipeCoin.physicsBody?.contactTestBitMask = collision.bird.rawValue
        
        pipePair.addChild(pipeCoin)
        
        pipePair.run(pipesMoveAndRemove)
        
        self.addChild(pipePair)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if !gameStartFlag {
                gameStartFlag = true
                tapTutorialNode.removeFromParent()
                bird?.physicsBody?.affectedByGravity = true
                self.startGame()
            } else {
                degreeChange()
                play(0)
                bird?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 28))
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = contact.bodyA
        var secondBody = contact.bodyB
        
        if (firstBody.node?.physicsBody?.categoryBitMask)! < (secondBody.node?.physicsBody?.categoryBitMask)! {
             firstBody = contact.bodyA
             secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == collision.bird.rawValue && secondBody.categoryBitMask == collision.coin.rawValue {
            score += 1
            scoreLabel.text = "\(score)"
            secondBody.node?.removeFromParent()
            play(1)
        } else {
            if score > UserDefaults.standard.integer(forKey: "highScore") {
                UserDefaults.standard.set(score, forKey: "score")
                UserDefaults.standard.set(score, forKey: "highScore")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.set(score, forKey: "score")
                UserDefaults.standard.synchronize()
            }

            play(2)
            firstBody.node?.removeFromParent()

            let transActBlock = SKAction.run {
                let gameS = GameOverScene(size: self.size)
                self.view?.presentScene(gameS)
            }

            let finalTrans = SKAction.sequence([SKAction.wait(forDuration: 0.1),transActBlock])
            run(finalTrans)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let value = (bird?.physicsBody?.velocity.dy)! * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        bird?.run(rotate)
    }
}//

extension GameScene {
    func play(_ index:Int) {
        run(sounds[index])
    }
}
