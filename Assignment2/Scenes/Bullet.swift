//
//  Bullet.swift
//
//  Created by Aryan Mantrawadi on 2025-04-09.
//  Copyright © 2025 Aryan Mantrawadi. All rights reserved.
//

import SpriteKit

// Bullet class to represent the bullets shot by the ship
class Bullet: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "bullet.png") // Use a bullet image or create a rectangle
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
