// Import necessary SpriteKit and GameplayKit frameworks
import SpriteKit
import GameplayKit

// Define a struct for physics categories, each represents an object type for collision detection
struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let ship: UInt32 = 0b1
    static let alien: UInt32 = 0b10
    static let gem: UInt32 = 0b100
    static let bullet: UInt32 = 0b1000
}

// Bullet class to represent the bullets shot by the ship
class Bullet: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "bullet.png")
        super.init(texture: texture, color: .clear, size: texture.size())

        xScale = 0.5
        yScale = 0.5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    private let background = SKSpriteNode(imageNamed: "galaxy.png")

    private var badGuyCount = 0
    private var score = 0
    private let scoreIncrement = 10
    private var lblScore: SKLabelNode?

    private var timerCount = 0
    private let timeLimit = 60
    private var timer = Timer()
    private var lblTime: SKLabelNode?

    private let defaults = UserDefaults.standard
    private var highScore = UserDefaults.standard.integer(forKey: "HIGHSCORE")
    private var lblHigh: SKLabelNode?

    private var sportNode: SKSpriteNode?
    private var isGameOver = false

    override func didMove(to view: SKView) {
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.alpha = 0.2
        addChild(background)

        label = childNode(withName: "//MyGame") as? SKLabelNode
        if let label = label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

        sportNode = SKSpriteNode(imageNamed: "ship.png")
        sportNode?.position = CGPoint(x: frame.size.width / 2, y: 100)
        if let sportNode = sportNode {
            addChild(sportNode)
            sportNode.physicsBody = SKPhysicsBody(circleOfRadius: sportNode.size.width / 2)
            sportNode.physicsBody?.isDynamic = true
            sportNode.physicsBody?.categoryBitMask = PhysicsCategory.ship
            sportNode.physicsBody?.contactTestBitMask = PhysicsCategory.alien
            sportNode.physicsBody?.collisionBitMask = PhysicsCategory.none
            sportNode.physicsBody?.usesPreciseCollisionDetection = true
        }

        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self

        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run { [weak self] in self?.addGemObject() },
            SKAction.wait(forDuration: 2.0)
        ])))

        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run { [weak self] in
                let duration = self?.random(min: 3.0, max: 5.0) ?? 4.0
                self?.addAlien(slowDownDuration: duration)
            },
            SKAction.wait(forDuration: 1.5)
        ])))

        lblTime = childNode(withName: "//timerCount") as? SKLabelNode
        lblScore = childNode(withName: "//score") as? SKLabelNode
        lblHigh = childNode(withName: "//highScore") as? SKLabelNode

        timerCount = timeLimit
        lblTime?.text = "Time Left: \(timerCount)"
        lblScore?.text = "Score: \(score)"
        lblHigh?.text = "High Score: \(highScore)"

        startCounter()
    }

    private func startCounter() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.decrementCounter()
        }
    }

    @objc private func decrementCounter() {
        guard !isGameOver else { return }

        if timerCount <= 1 {
            gameOver()
            return
        }

        timerCount -= 1
        score += 1
        lblTime?.text = "Time Left: \(timerCount)"
    }

    private func random() -> CGFloat {
        CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    private func random(min: CGFloat, max: CGFloat) -> CGFloat {
        random() * (max - min) + min
    }

    private func addAlien(slowDownDuration: CGFloat? = nil) {
        guard !isGameOver else { return }

        let alien = SKSpriteNode(imageNamed: "alien.png")
        alien.yScale *= -1
        let actualX = random(min: alien.size.width / 2, max: size.width - alien.size.width / 2)
        alien.position = CGPoint(x: actualX, y: size.height + alien.size.height / 2)
        addChild(alien)

        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.physicsBody?.categoryBitMask = PhysicsCategory.alien
        alien.physicsBody?.contactTestBitMask = PhysicsCategory.ship
        alien.physicsBody?.collisionBitMask = PhysicsCategory.none

        let actualDuration = slowDownDuration ?? random(min: 2.0, max: 4.0)
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -alien.size.height / 2), duration: TimeInterval(actualDuration))
        alien.run(SKAction.sequence([actionMove, SKAction.removeFromParent()]))
    }

    private func addGemObject() {
        guard !isGameOver else { return }

        let gem = SKSpriteNode(imageNamed: "gem.png")
        let actualX = random(min: gem.size.width / 2, max: size.width - gem.size.width / 2)
        gem.position = CGPoint(x: actualX, y: size.height + gem.size.height / 2)
        addChild(gem)

        gem.physicsBody = SKPhysicsBody(rectangleOf: gem.size)
        gem.physicsBody?.isDynamic = true
        gem.physicsBody?.categoryBitMask = PhysicsCategory.gem
        gem.physicsBody?.contactTestBitMask = PhysicsCategory.ship
        gem.physicsBody?.collisionBitMask = PhysicsCategory.none
        gem.physicsBody?.usesPreciseCollisionDetection = true

        let actualDuration = random(min: 2.0, max: 4.0)
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -gem.size.height / 2), duration: TimeInterval(actualDuration))
        gem.run(SKAction.sequence([actionMove, SKAction.removeFromParent()]))

        if badGuyCount % 5 == 0 {
            badAlien()
        }
    }

    private func badAlien() {
        badGuyCount += 1
        addGemObject()
    }

    private func shipCollideAlien(ship: SKSpriteNode, alien: SKSpriteNode) {
        alien.removeFromParent()
        gameOver()
    }

    private func shipCollideGem(ship: SKSpriteNode, gem: SKSpriteNode) {
        gem.removeFromParent()
        score += scoreIncrement
        highScore = max(highScore, score)
        updateScoreLabels()
    }

    private func updateScoreLabels() {
        lblScore?.text = "Score: \(score)"
        lblHigh?.text = "High Score: \(highScore)"
    }

    private func shootBullet() {
        guard let sportNode = sportNode else { return }

        let bullet = Bullet()
        bullet.position = CGPoint(x: sportNode.position.x, y: sportNode.position.y + (sportNode.size.height / 2))

        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.alien
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.none

        addChild(bullet)

        let moveUp = SKAction.moveBy(x: 0, y: size.height, duration: 2.0)
        bullet.run(SKAction.sequence([moveUp, SKAction.removeFromParent()]))
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        if (bodyA.categoryBitMask & PhysicsCategory.alien != 0 && bodyB.categoryBitMask & PhysicsCategory.bullet != 0) ||
            (bodyB.categoryBitMask & PhysicsCategory.alien != 0 && bodyA.categoryBitMask & PhysicsCategory.bullet != 0) {
            if let alienNode = (bodyA.categoryBitMask & PhysicsCategory.alien != 0 ? bodyA.node : bodyB.node) as? SKSpriteNode,
               let bulletNode = (bodyA.categoryBitMask & PhysicsCategory.bullet != 0 ? bodyA.node : bodyB.node) as? Bullet {
                bulletNode.removeFromParent()
                alienNode.removeFromParent()

                score += 1
                updateScoreLabels()
                addAlien(slowDownDuration: random(min: 3.0, max: 5.0))
            }
        }

        if (bodyA.categoryBitMask & PhysicsCategory.gem != 0 && bodyB.categoryBitMask & PhysicsCategory.ship != 0) ||
            (bodyB.categoryBitMask & PhysicsCategory.gem != 0 && bodyA.categoryBitMask & PhysicsCategory.ship != 0) {
            if let gemNode = (bodyA.categoryBitMask & PhysicsCategory.gem != 0 ? bodyA.node : bodyB.node) as? SKSpriteNode {
                gemNode.removeFromParent()
                shipCollideGem(ship: sportNode ?? SKSpriteNode(), gem: gemNode)
            }
        }

        if (bodyA.categoryBitMask & PhysicsCategory.alien != 0 && bodyB.categoryBitMask & PhysicsCategory.ship != 0) ||
            (bodyB.categoryBitMask & PhysicsCategory.alien != 0 && bodyA.categoryBitMask & PhysicsCategory.ship != 0) {
            if let alienNode = (bodyA.categoryBitMask & PhysicsCategory.alien != 0 ? bodyA.node : bodyB.node) as? SKSpriteNode {
                shipCollideAlien(ship: sportNode ?? SKSpriteNode(), alien: alienNode)
            }
        }
    }

    private func saveHighScore() {
        if score > highScore {
            highScore = score
            defaults.set(highScore, forKey: "HIGHSCORE")
            defaults.synchronize()
        }
    }

    private func gameOver() {
        guard !isGameOver else { return }
        isGameOver = true
        timer.invalidate()

        if let overGame = GameOverScene(fileNamed: "OverScene") {
            overGame.scaleMode = .aspectFill
            view?.presentScene(overGame, transition: SKTransition.fade(withDuration: 0.3))
        }

        saveHighScore()
    }

    private func moveShip(toPoint pos: CGPoint) {
        guard let sportNode = sportNode else { return }
        let actionMove = SKAction.move(to: CGPoint(x: pos.x, y: sportNode.position.y), duration: 0.2)
        sportNode.run(actionMove)
    }

    private func touchDown(atPoint pos: CGPoint) {
        shootBullet()
        moveShip(toPoint: pos)
    }

    private func touchMoved(toPoint pos: CGPoint) {
        if let n = spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = SKColor.blue
            addChild(n)
        }
        moveShip(toPoint: pos)
    }

    private func touchUp(atPoint pos: CGPoint) {
        if let n = spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = SKColor.red
            addChild(n)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = label {
            label.run(SKAction(named: "Pulse")!, withKey: "fadeInOut")
        }
        for touch in touches {
            touchDown(atPoint: touch.location(in: self))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchMoved(toPoint: touch.location(in: self))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchUp(atPoint: touch.location(in: self))
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchUp(atPoint: touch.location(in: self))
        }
    }

    override func update(_ currentTime: TimeInterval) {
    }
}
