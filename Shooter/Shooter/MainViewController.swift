//
//  GameViewController.swift
//  Shooter
//
//  Created by Argentino Ducret on 6/7/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

public struct PhysicsCategory {
    
    static let Player: UInt32 = 1
    static let Grass: UInt32 = 2
    static let Wall: UInt32 = 4
    static let Enemy: UInt32 = 8
    static let Shot: UInt32 = 16
    static let Life: UInt32 = 32
}

public class MainViewController: UIViewController {
    
    fileprivate var scene: MenuScene!
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override var shouldAutorotate: Bool {
        return true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: view.bounds)
        skView.ignoresSiblingOrder = true
        
        // This is just for debug
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.showsPhysics = true
        
        scene = MenuScene(fileNamed: "MenuScene")
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        view.insertSubview(skView, at: 0)
    }
    
}
