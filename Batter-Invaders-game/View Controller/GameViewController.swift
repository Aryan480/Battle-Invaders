//
//  GameViewController.swift
//  Assignment2
//
//  Created by Aryan Mantrawadi on 2020-11-09.
//  Copyright © 2020 Aryan Mantrawadi. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let skView = self.view as? SKView {
            if let scene = StartGameScene(fileNamed: "StartScene") {
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            }

            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}
