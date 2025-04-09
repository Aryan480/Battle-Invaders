//
//  StartGameScene.swift
//
//  Created by Aryan Mantrawadi on 2020-11-10.
//  Copyright © 2020 Aryan Mantrawadi. All rights reserved.
//

import SpriteKit  // Import the SpriteKit framework for 2D games

class StartGameScene: SKScene {  // Define a scene class that inherits from SKScene (a game screen)
    
    override func didMove(to view: SKView) {  // Called when the scene appears on the screen
        // Setup code can go here (e.g., background, labels)
    }
    
    // Called when the user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let playGame = GameScene(fileNamed: "GameScene")  // Load the main game scene from the file "GameScene.sks"
        playGame?.scaleMode = .aspectFill  // Set the scene's scaling to fill the screen while preserving aspect ratio
        self.view?.presentScene(playGame!, transition: SKTransition.fade(withDuration: 0.2))
        // Present the new scene with a fade transition lasting 0.2 seconds
    }
}


   


    

    
