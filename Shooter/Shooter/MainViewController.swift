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
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
        scene = MenuScene(fileNamed: "MenuScene")
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        view.insertSubview(skView, at: 0)
    }
    
}
