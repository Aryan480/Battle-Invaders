//
//  GameOverScene.swift
//  Assignment2
//
//  Created by Aryan Mantrawadi on 2020-11-10.
//  Copyright © 2020 Aryan Mantrawadi. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {  // Define a new scene class for the Game Over screen
    
    override func didMove(to view: SKView) {  // Called when the scene appears on the screen
        // Setup code for the Game Over screen can go here (e.g., labels, buttons)
    }
    
    // Called when the user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                
        let startGame = StartGameScene(fileNamed: "StartScene")  // Load the Start scene from the file "StartScene.sks"
        startGame?.scaleMode = .aspectFill  // Set the scene's scaling to fill the screen while preserving aspect ratio
        self.view?.presentScene(startGame!, transition: SKTransition.fade(withDuration: 0.2))
        // Present the new scene with a fade transition lasting 0.2 seconds
    }
}
    

    
   


        
    
    

    

    

