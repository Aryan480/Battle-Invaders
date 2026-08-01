//
//  StartGameScene.swift
//
//  Created by Aryan Mantrawadi on 2020-11-10.
//  Copyright © 2020 Aryan Mantrawadi. All rights reserved.
//

import SpriteKit

class StartGameScene: SKScene {

    override func didMove(to view: SKView) {
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let playGame = GameScene(fileNamed: "GameScene") else { return }
        playGame.scaleMode = .aspectFill
        view?.presentScene(playGame, transition: SKTransition.fade(withDuration: 0.2))
    

    
