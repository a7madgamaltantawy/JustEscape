//
//  GameScene.swift
//  JustEscape
//
//  Created by Ahmed Tantawy on 10/04/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    let possibleEnemies = ["ball","hummer", "tv"]
    var isGameOver = false
    var gameTimer : Timer?
    
    
    
    
    
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!

    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024 , y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        // adding the player
        
         player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        // adding score label
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 40)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self

        
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    
    
    
  
    
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
    }
    
   
    
    @objc func createEnemy(){
        
        guard let enemy = possibleEnemies.randomElement() else {
            return
        }
        
         let sprite = SKSpriteNode(imageNamed: enemy)
        
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...700))
        
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    
    override func update(_ currentTime : TimeInterval){
        
        for node in children{
            
            if node.position.x < -300{
                
                node.removeFromParent()
            }
            
        }
        if !isGameOver {
            
            score += 1
        }
        
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        
        var location = touch.location(in: self)
        
        
        player.position = location
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        let explosion  = SKEmitterNode(fileNamed: "explosion")!
        
        explosion.position = player.position
        addChild(explosion)
        player.removeFromParent()
        isGameOver = true
        
        
        
    }
  
}
