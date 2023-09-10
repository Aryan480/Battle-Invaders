//
//  StartGameScene.swift
//  Assignment2
//
//  Created by Aryan Mantrawadi on 2020-11-10.
//  Copyright © 2020 Aryan Mantrawadi. All rights reserved.
//

import SpriteKit

class StartGameScene: SKScene {
    override func didMove(to view: SKView) {
        
    }
    
    //transition to game scene when touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        let playGame = GameScene(fileNamed: "GameScene")
        playGame?.scaleMode = .aspectFill
        self.view?.presentScene(playGame!, transition: SKTransition.fade(withDuration: 0.2))
                    
    }
    

    
}


   


    

    
