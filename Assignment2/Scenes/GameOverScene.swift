//
//  GameOverScene.swift
//  Assignment2
//
//  Created by Aryan Mantrawadi on 2020-11-10.
//  Copyright © 2020 Aryan Mantrawadi. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        
    }
    
    //transition to start scene when touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
                
            let startGame = StartGameScene(fileNamed: "StartScene")
            startGame?.scaleMode = .aspectFill
            self.view?.presentScene(startGame!, transition: SKTransition.fade(withDuration: 0.2))
             }
    }
    

    
   


        
    
    

    

    

