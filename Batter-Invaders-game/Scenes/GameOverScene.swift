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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let startGame = StartGameScene(fileNamed: "StartScene") else { return }
        startGame.scaleMode = .aspectFill
        view?.presentScene(startGame, transition: SKTransition.fade(withDuration: 0.2))
    

    

    

