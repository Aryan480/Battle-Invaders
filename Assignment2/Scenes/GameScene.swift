//
//  GameScene.swift
//  Assignment2
//
//  Created by Aryan Mantrawadi on 2020-11-09.
//  Copyright © 2020 Aryan Mantrawadi. All rights reserved.
//

import SpriteKit
import GameplayKit

//Physics categories struct for each object
struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = UInt32.max
    static let Ship: UInt32 = 0b1
    static let Alien: UInt32 = 0b10
    static let Gem: UInt32 = 0b11
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var background = SKSpriteNode(imageNamed: "galaxy.png")
    
    //adding counter to detect fifth object
    var badGuyCount : Int = 0
    
    //add score
    private var score : Int = 0
    let scoreInc = 10
    private var lblScore: SKLabelNode?
    
    //add timer
    private var timerCount : Int = 0
    var timeInt = 60
    var timer = Timer()
    private var lblTime: SKLabelNode?
    
    //add highscore and user defaults
    let defaults = UserDefaults.standard
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE")
    private var hScore : Int = 0
    private var lblHigh: SKLabelNode?

    
    private var sportNode : SKSpriteNode?
    
    //start timer
    func startCounter(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
        
      }
      
    //decrement timer and end game
      @objc func decrementCounter(){
        if timerCount == 1{
            GameOver()
        }
          timerCount -= 1
        
        //add score every second
          score += 1
          self.lblTime?.text = "Time Left: \(timerCount)"
      }

    override func didMove(to view: SKView) {
        
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.alpha = 0.2
        addChild(background)
        
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//MyGame") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        //adding good guy
        sportNode = SKSpriteNode(imageNamed: "ship.png")
        sportNode?.position = CGPoint(x : 150, y : 150)

        
        addChild(sportNode!)
        
        //adding physics to the good guy
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self;

        sportNode?.physicsBody = SKPhysicsBody(circleOfRadius:(sportNode?.size.width)!/2)
        sportNode?.physicsBody?.isDynamic = true;
        sportNode?.physicsBody?.categoryBitMask = PhysicsCategory.Ship
        sportNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        sportNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        sportNode?.physicsBody?.usesPreciseCollisionDetection = true;

        //run the bad guy and the object
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addGem5thObject), SKAction.wait(forDuration: 2.0)])))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addAlien), SKAction.wait(forDuration: 0.5)])))
        
        //displaying timer, score, highscore
        self.lblTime = self.childNode(withName: "//timerCount") as? SKLabelNode
        self.lblScore = self.childNode(withName: "//score") as? SKLabelNode
        self.lblHigh = self.childNode(withName: "//highScore") as? SKLabelNode
        timerCount = timeInt
        startCounter()
    }
    
    func badAlien(){
        badGuyCount += 1
        addGem5thObject()
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min:CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max-min) + min
    }
    
    //adding bad guy alien
    func addAlien(){
           
           let alien = SKSpriteNode(imageNamed: "alien.png")
           alien.yScale = alien.yScale * -1
           
           let actualX = random(min: alien.size.height/2, max: size.height-alien.size.height/2)
           
           alien.position = CGPoint(x: actualX, y:size.width + alien.size.width/2)
           
           addChild(alien)
           
           alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
           alien.physicsBody?.isDynamic = true;
           alien.physicsBody?.categoryBitMask = PhysicsCategory.Alien
           alien.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
           alien.physicsBody?.collisionBitMask = PhysicsCategory.None
           
           let actualDuration = random(min: CGFloat(2.0), max:CGFloat(4.0))
                  
           let actionMove = SKAction.move(to: CGPoint(x: actualX , y: -alien.size.width/2), duration: TimeInterval(actualDuration))
                          
           let actionMoveDone = SKAction.removeFromParent()
               alien.run(SKAction.sequence([actionMove, actionMoveDone]))
       }

    //adding gems
    func addGem5thObject(){
        
        let gem = SKSpriteNode(imageNamed: "gem.png")
        gem.yScale = gem.yScale
        
         let actualX = random(min: gem.size.height/2, max: size.height-gem.size.height/2)
        
         gem.position = CGPoint(x: actualX, y:size.width + gem.size.width/2)
        
        addChild(gem)
        
        gem.physicsBody = SKPhysicsBody(rectangleOf: gem.size)
        gem.physicsBody?.isDynamic = true;
        gem.physicsBody?.categoryBitMask = PhysicsCategory.Gem
        gem.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
        gem.physicsBody?.collisionBitMask = PhysicsCategory.None
        gem.physicsBody?.usesPreciseCollisionDetection = true;

        
        let actualDuration = random(min: CGFloat(2.0), max:CGFloat(4.0))
               
        let actionMove = SKAction.move(to: CGPoint(x: actualX , y: -gem.size.width/2), duration: TimeInterval(actualDuration))
                       
        let actionMoveDone = SKAction.removeFromParent()
            gem.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        if badGuyCount % 5 == 0{
            badAlien()
        }
    }
    
   //collision dection when ship hits alien
    func shipCollideAlien(ship: SKSpriteNode, alien: SKSpriteNode){
        
                 print("alien")
        
        }

    //collision dection when ship hits gem, score increase
    func shipCollideGem(ship: SKSpriteNode, gem: SKSpriteNode){
        score = score + scoreInc
        //setting current score as high score
        hScore = score
        self.lblScore?.text = "Score: \(score)"
        let score = self.lblScore
            score?.alpha = 0.0
            score?.run(SKAction.fadeIn(withDuration: 2.0))
            print("gem")
        
        self.lblHigh?.text = "High Score: \(hScore)"
        if let hScore = self.lblHigh{
            hScore.alpha = 0.0
            hScore.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }
    
    //detect collision when hit
    func didBegin(_ contact: SKPhysicsContact) {
        
          var firstBody : SKPhysicsBody
          var secondBody : SKPhysicsBody
    
          if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
              firstBody = contact.bodyA
              secondBody = contact.bodyB
            
          }else{
              firstBody = contact.bodyB
              secondBody = contact.bodyA
          }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Alien != 0) &&
              (secondBody.categoryBitMask & PhysicsCategory.Ship != 0)){
            shipCollideAlien(ship: firstBody.node as! SKSpriteNode, alien: secondBody.node as! SKSpriteNode)
        }
            
         else if ((firstBody.categoryBitMask & PhysicsCategory.Gem != 0) &&
              (secondBody.categoryBitMask & PhysicsCategory.Ship != 0)){
            shipCollideGem(ship: secondBody.node as! SKSpriteNode, gem: firstBody.node as! SKSpriteNode)
        }
    }
    
    //save high score in user defaults
    func saveHighScore(){
          if score > highScore {
              defaults.set(hScore, forKey: "HIGHSCORE")
              defaults.synchronize()
          }
      }

    //transit scene to game over scene
      func GameOver(){
          
        //invalidate time
          timer.invalidate()
          
        //when game is over transit to scene
           let overGame = GameOverScene(fileNamed: "OverScene")
          overGame?.scaleMode = .aspectFill
          self.view?.presentScene(overGame!, transition: SKTransition.fade(withDuration: 0.3))
        
        saveHighScore()

      }

    //move the ship
    func moveShip(toPoint pos: CGPoint){
        
        let actionMove = SKAction.move(to: CGPoint(x: pos.x ,y: (sportNode?.position.y)!), duration: TimeInterval(2.0))
        
                
        sportNode?.run(SKAction.sequence([actionMove]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        
        moveShip(toPoint: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
        moveShip(toPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self))
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self))
            

        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}
    
    

