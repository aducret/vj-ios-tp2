//
//  MenuScene.swift
//  Shooter
//
//  Created by Argentino Ducret on 6/7/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit
import Foundation

public class MenuScene: SKScene, SKPhysicsContactDelegate {
    
    public var stateText = ""
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        initializeScene(view)
        let stateLabel = children.first { $0.name ?? "" == "State"} as! SKLabelNode
        if stateText == "" {
            stateLabel.isHidden = true
        } else {
            stateLabel.isHidden = false
            stateLabel.text = stateText
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches
            .map { $0.location(in: self) }
            .map { nodes(at: $0) }
            .forEach {
                $0.forEach {
                    if "Play" == $0.name ?? "" {
                        let transition = SKTransition.reveal(with: .down, duration: 1.0)
                        let nextScene = MainScene(fileNamed: "MainScene")
                        nextScene?.scaleMode = .aspectFill
                        view?.presentScene(nextScene!, transition: transition)
                    }
                }
        }
        
    }
}

// MARK: - Private Methods
fileprivate extension MenuScene {
    
    fileprivate func initializeScene(_ view: SKView) {
        size = view.frame.size
        scaleMode = .resizeFill
    }
    
}
