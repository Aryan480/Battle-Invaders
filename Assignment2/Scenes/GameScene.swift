// Import necessary SpriteKit and GameplayKit frameworks
import SpriteKit
import GameplayKit

// Define a struct for physics categories, each represents an object type for collision detection
struct PhysicsCategory {
    static let None: UInt32 = 0 // Represents no collision
    static let All: UInt32 = UInt32.max // Represents all objects
    static let Ship: UInt32 = 0b1 // Represents the player's ship
    static let Alien: UInt32 = 0b10 // Represents aliens
    static let Gem: UInt32 = 0b11 // Represents gems
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Declare variables for various game elements like labels, nodes, and background
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var background = SKSpriteNode(imageNamed: "galaxy.png") // Background image for the scene
    
    // Initialize counters for bad guys and score
    var badGuyCount : Int = 0
    private var score : Int = 0
    let scoreInc = 10 // Increment score by 10 for each gem collected
    private var lblScore: SKLabelNode?
    
    // Initialize variables for the timer and related UI
    private var timerCount : Int = 0
    var timeInt = 60 // Game duration in seconds
    var timer = Timer() // Timer to decrement each second
    private var lblTime: SKLabelNode?
    
    // Variables for high score and UserDefaults storage
    let defaults = UserDefaults.standard
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE") // Retrieve high score from UserDefaults
    private var hScore : Int = 0
    private var lblHigh: SKLabelNode?

    // Sprite node for the player's ship
    private var sportNode : SKSpriteNode?
    
    // Function to start the game timer
    func startCounter(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
    }

    // Function to decrement the timer and update score
    @objc func decrementCounter(){
        if timerCount == 1{
            GameOver() // End the game when time runs out
        }
        timerCount -= 1
        score += 1 // Increase score every second
        self.lblTime?.text = "Time Left: \(timerCount)" // Update timer UI
    }

    // Called when the scene is loaded into view
    override func didMove(to view: SKView) {
        
        // Set up background image position and transparency
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.alpha = 0.2 // Set the opacity of the background
        addChild(background) // Add background to the scene
        
        // Set up label node and fade it in
        self.label = self.childNode(withName: "//MyGame") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0 // Initially hidden
            label.run(SKAction.fadeIn(withDuration: 2.0)) // Fade it in over 2 seconds
        }

        // Create a shape node for interaction feedback
        let w = (self.size.width + self.size.height) * 0.05 // Width based on scene size
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3) // Create a square with rounded corners

        // If spinnyNode is initialized, set its properties and add animation
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5 // Set the border width
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1))) // Spin it continuously
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5), // Fade out
                                              SKAction.removeFromParent()])) // Remove it after fading
        }

        // Create the player’s ship sprite
        sportNode = SKSpriteNode(imageNamed: "ship.png")
        sportNode?.position = CGPoint(x : 150, y : 150) // Place ship at (150, 150)
        addChild(sportNode!) // Add the ship to the scene
        
        // Set up physics for the ship
        physicsWorld.gravity = CGVector(dx: 0, dy: 0) // No gravity
        physicsWorld.contactDelegate = self; // Set contact delegate for collision detection
        sportNode?.physicsBody = SKPhysicsBody(circleOfRadius:(sportNode?.size.width)!/2) // Create a circular physics body around the ship
        sportNode?.physicsBody?.isDynamic = true; // Enable physics simulation
        sportNode?.physicsBody?.categoryBitMask = PhysicsCategory.Ship // Set the category to Ship
        sportNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Alien // Detect collision with aliens
        sportNode?.physicsBody?.collisionBitMask = PhysicsCategory.None // No collision with other objects
        sportNode?.physicsBody?.usesPreciseCollisionDetection = true; // Use precise collision detection

        // Add actions to spawn gems and aliens
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addGem5thObject), SKAction.wait(forDuration: 2.0)]))) // Add a gem every 2 seconds
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addAlien), SKAction.wait(forDuration: 0.5)]))) // Add an alien every 0.5 seconds

        // Set up score, timer, and high score UI labels
        self.lblTime = self.childNode(withName: "//timerCount") as? SKLabelNode
        self.lblScore = self.childNode(withName: "//score") as? SKLabelNode
        self.lblHigh = self.childNode(withName: "//highScore") as? SKLabelNode
        timerCount = timeInt // Initialize timer count to the game duration
        startCounter() // Start the countdown timer
    }
    
    // Function to increment bad guy count and add a gem
    func badAlien(){
        badGuyCount += 1
        addGem5thObject() // Add a gem
    }
    
    // Random number generator between 0 and 1
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) // Generate random CGFloat between 0 and 1
    }
    
    // Random number generator between a specific min and max range
    func random(min:CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max-min) + min // Return random number within the range
    }

    // Function to spawn an alien sprite
    func addAlien(){
        let alien = SKSpriteNode(imageNamed: "alien.png") // Create alien sprite
        alien.yScale = alien.yScale * -1 // Flip the alien upside down
        let actualX = random(min: alien.size.height/2, max: size.height-alien.size.height/2) // Random X position within the screen
        alien.position = CGPoint(x: actualX, y:size.width + alien.size.width/2) // Set position outside the screen (above)
        addChild(alien) // Add the alien to the scene
        
        // Set up alien physics
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size) // Create physics body for alien
        alien.physicsBody?.isDynamic = true; // Enable physics simulation
        alien.physicsBody?.categoryBitMask = PhysicsCategory.Alien // Set the category to Alien
        alien.physicsBody?.contactTestBitMask = PhysicsCategory.Ship // Detect collision with the ship
        alien.physicsBody?.collisionBitMask = PhysicsCategory.None // No collision with other objects
        
        // Randomize the movement duration of the alien
        let actualDuration = random(min: CGFloat(2.0), max:CGFloat(4.0))
        let actionMove = SKAction.move(to: CGPoint(x: actualX , y: -alien.size.width/2), duration: TimeInterval(actualDuration)) // Move alien downwards
        let actionMoveDone = SKAction.removeFromParent() // Remove alien when it reaches the bottom
        alien.run(SKAction.sequence([actionMove, actionMoveDone])) // Run the move action
    }

    // Function to spawn a gem sprite
    func addGem5thObject(){
        let gem = SKSpriteNode(imageNamed: "gem.png") // Create gem sprite
        gem.yScale = gem.yScale // Scale the gem sprite
        let actualX = random(min: gem.size.height/2, max: size.height-gem.size.height/2) // Random X position for gem
        gem.position = CGPoint(x: actualX, y:size.width + gem.size.width/2) // Set gem position above the screen
        addChild(gem) // Add gem to the scene
        
        // Set up gem physics
        gem.physicsBody = SKPhysicsBody(rectangleOf: gem.size) // Create physics body for gem
        gem.physicsBody?.isDynamic = true; // Enable physics simulation
        gem.physicsBody?.categoryBitMask = PhysicsCategory.Gem // Set category to Gem
        gem.physicsBody?.contactTestBitMask = PhysicsCategory.Ship // Detect collision with the ship
        gem.physicsBody?.collisionBitMask = PhysicsCategory.None // No collision with other objects
        gem.physicsBody?.usesPreciseCollisionDetection = true; // Use precise collision detection
        
        // Randomize the movement duration of the gem
        let actualDuration = random(min: CGFloat(2.0), max:CGFloat(4.0))
        let actionMove = SKAction.move(to: CGPoint(x: actualX , y: -gem.size.width/2), duration: TimeInterval(actualDuration)) // Move gem downwards
        let actionMoveDone = SKAction.removeFromParent() // Remove gem when it reaches the bottom
        gem.run(SKAction.sequence([actionMove, actionMoveDone])) // Run the move action

        // Add a bad alien every 5th gem
        if badGuyCount % 5 == 0{
            badAlien() // Add a bad alien
        }
    }

    // Handle collision between ship and alien (no specific action here yet)
    func shipCollideAlien(ship: SKSpriteNode, alien: SKSpriteNode){
        print("alien") // Log that a collision with an alien occurred
    }

    // Handle collision between ship and gem (increase score)
    func shipCollideGem(ship: SKSpriteNode, gem: SKSpriteNode){
        score = score + scoreInc // Increase score by scoreInc
        hScore = score // Set high score to current score
        self.lblScore?.text = "Score: \(score)" // Update score label
        let score = self.lblScore
        score?.alpha = 0.0
        score?.run(SKAction.fadeIn(withDuration: 2.0)) // Fade in the score label
        
        print("gem") // Log that a gem was collected
        
        self.lblHigh?.text = "High Score: \(hScore)" // Update high score label
        if let hScore = self.lblHigh{
            hScore.alpha = 0.0
            hScore.run(SKAction.fadeIn(withDuration: 2.0)) // Fade in the high score label
        }
    }

    // Detect collisions between different objects
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody

        // Ensure firstBody is always the smaller category
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        // Handle collision between alien and ship
        if ((firstBody.categoryBitMask & PhysicsCategory.Alien != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ship != 0)){
            shipCollideAlien(ship: firstBody.node as! SKSpriteNode, alien: secondBody.node as! SKSpriteNode)
        }
        // Handle collision between gem and ship
        else if ((firstBody.categoryBitMask & PhysicsCategory.Gem != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ship != 0)){
            shipCollideGem(ship: secondBody.node as! SKSpriteNode, gem: firstBody.node as! SKSpriteNode)
        }
    }

    // Save the high score to UserDefaults if the current score is higher
    func saveHighScore(){
        if score > highScore {
            defaults.set(hScore, forKey: "HIGHSCORE") // Save the new high score
            defaults.synchronize() // Synchronize UserDefaults
        }
    }

    // Transition to the Game Over scene
    func GameOver(){
        timer.invalidate() // Stop the timer
        let overGame = GameOverScene(fileNamed: "OverScene") // Load the game over scene
        overGame?.scaleMode = .aspectFill // Set the scaling mode for the new scene
        self.view?.presentScene(overGame!, transition: SKTransition.fade(withDuration: 0.3)) // Transition with fade effect
        saveHighScore() // Save the high score
    }

    // Function to move the ship to a specific point
    func moveShip(toPoint pos: CGPoint){
        let actionMove = SKAction.move(to: CGPoint(x: pos.x ,y: (sportNode?.position.y)!), duration: TimeInterval(2.0)) // Move ship to the target
        sportNode?.run(SKAction.sequence([actionMove])) // Execute the move action
    }

    // Handle touch down event
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n) // Add a visual feedback node
        }
        moveShip(toPoint: pos) // Move the ship
    }
    
    // Handle touch moved event
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n) // Add a visual feedback node
        }
        moveShip(toPoint: pos) // Move the ship
    }
    
    // Handle touch up event
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n) // Add a visual feedback node
        }
    }

    // Handle touches began event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut") // Apply pulse animation to the label
        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) } // Call touchDown on each touch
    }

    // Handle touches moved event
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) } // Call touchMoved on each touch
    }

    // Handle touches ended event
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) } // Call touchUp on each touch
    }

    // Handle touches cancelled event
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) } // Call touchUp when touch is cancelled
    }
    
    // Update method for custom updates, not used here
    override func update(_ currentTime: TimeInterval) {
        
    }
}
