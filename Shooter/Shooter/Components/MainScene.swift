//
//  MainScene.swift
//  Shooter
//
//  Created by Argentino Ducret on 6/7/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit
import Foundation

public class MainScene: SKScene, SKPhysicsContactDelegate {
    
    fileprivate var player: Player!
    fileprivate var lastInterval: TimeInterval? = .none
    fileprivate var enemies: [Enemy]!
    
    fileprivate let lifesLabel = SKLabelNode(fontNamed: "Apple Symbols")
    fileprivate let enemiesLabel = SKLabelNode(fontNamed: "Apple Symbols")
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        configureWorld()
        updateNodes()
        addCamera()
        
        enemies = children.filter { $0.name ?? "" == "Enemy"}.map { $0 as! Enemy }
        enemies.forEach { $0.player = player }
        
        addLabels()
    }
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        let win = enemies.reduce(true) { $0 && $1.parent == nil }
        if win {
            let transition = SKTransition.reveal(with: .up, duration: 1.0)
            let nextScene = MenuScene(fileNamed: "MenuScene")
            nextScene!.scaleMode = .aspectFill
            nextScene!.stateText = "You WIN!!!"
            view?.presentScene(nextScene!, transition: transition)
            return
        }
        
        if player.parent == nil {
            print("Loss!")
            let transition = SKTransition.reveal(with: .up, duration: 1.0)
            let nextScene = MenuScene(fileNamed: "MenuScene")
            nextScene!.scaleMode = .aspectFill
            nextScene!.stateText = "Game Over"
            view?.presentScene(nextScene!, transition: transition)
            return
        }
        
        if lastInterval == .none {
            lastInterval = currentTime
        }
        
        let delta = currentTime - lastInterval!
        
        player.updateMovement(byTimeDelta: delta)
        enemies.forEach {
            $0.updateMovement(byTimeDelta: delta)
        }
        
        lastInterval = currentTime
    }
    
    public override func didFinishUpdate() {
        super.didFinishUpdate()
        updateCamera(on: player)
        
        lifesLabel.text = "Lifes: \(player.lifes)"
        let enemiesCount = enemies.reduce(0) { $0 + ($1.parent == nil ? 0 : 1) }
        enemiesLabel.text = "Enemies: \(enemiesCount)"
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first?.location(in: self) {
            for node in nodes(at: touch) {
                if node.name == "Wall" {
                    break
                }
                
                if node.name == "Enemy" {
                    player.pointTouched = touch
                    break
                }
                
                if node.name == "Grass" {
                    player.pointTouched = touch
                }
            }
        }
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Enemy != 0) && (secondBody.categoryBitMask & PhysicsCategory.Shot != 0)) {
            if let shot = secondBody.node {
                shot.isHidden = true
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) && (secondBody.categoryBitMask & PhysicsCategory.Shot != 0)) {
            if let shot = secondBody.node {
                shot.isHidden = true
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Wall != 0) && (secondBody.categoryBitMask & PhysicsCategory.Shot != 0)) {
            if let shot = secondBody.node {
                shot.removeFromParent()
            }
        }
    }
    
    public  func didEnd(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Enemy != 0) && (secondBody.categoryBitMask & PhysicsCategory.Shot != 0)) {
            if let shot = secondBody.node {
                shot.removeFromParent()
            }
            if let enemy = firstBody.node as? Enemy {
                enemy.shooted()
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) && (secondBody.categoryBitMask & PhysicsCategory.Shot != 0)) {
            if let shot = secondBody.node {
                shot.removeFromParent()
            }
            
            player.shooted()
        }
    }
    
}

// MARK: - Private Methods
fileprivate extension MainScene {
    
    fileprivate func updateCamera(on node: SKSpriteNode) {
        let nodeFrame = node.calculateAccumulatedFrame()
        let cameraPositionX = nodeFrame.origin.x + nodeFrame.width / 2
        let cameraPositiony = nodeFrame.origin.y + nodeFrame.height / 2
        camera?.position = CGPoint(x: cameraPositionX, y: cameraPositiony)
    }
    
    fileprivate func addCamera() {
        let mainCamera = SKCameraNode()
        camera = mainCamera
        addChild(mainCamera)
    }
    
    fileprivate func updateNodes() {
        children
            .filter { $0.name == "Player" }
            .map { $0 as! SKSpriteNode }
            .forEach {
                $0.physicsBody = SKPhysicsBody(rectangleOf: $0.texture!.size())
                $0.physicsBody?.categoryBitMask = PhysicsCategory.Player
                $0.physicsBody?.contactTestBitMask = PhysicsCategory.Shot
                $0.physicsBody?.collisionBitMask = PhysicsCategory.Enemy | PhysicsCategory.Wall
                $0.physicsBody?.mass = 5
                $0.physicsBody?.affectedByGravity = false
                $0.physicsBody?.usesPreciseCollisionDetection = true
                self.player = $0 as! Player
        }
        
        children
            .filter { $0.name == "Grass" }
            .forEach {
                $0.physicsBody = SKPhysicsBody(rectangleOf: $0.frame.size)
                $0.physicsBody?.isDynamic = false
                $0.physicsBody?.categoryBitMask = PhysicsCategory.Grass
                $0.physicsBody?.contactTestBitMask = 0
                $0.physicsBody?.collisionBitMask = 0
        }
        
        children
            .filter { $0.name == "Wall" }
            .forEach {
                $0.physicsBody = SKPhysicsBody(rectangleOf: $0.frame.size)
                $0.physicsBody?.isDynamic = false
                $0.physicsBody?.categoryBitMask = PhysicsCategory.Wall
                $0.physicsBody?.contactTestBitMask = 0
                $0.physicsBody?.collisionBitMask = 0
        }
        
        children
            .filter { $0.name == "Enemy" }
            .map { $0 as! SKSpriteNode }
            .forEach {
                $0.physicsBody = SKPhysicsBody(rectangleOf: $0.texture!.size())
                $0.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
                $0.physicsBody?.contactTestBitMask = PhysicsCategory.Shot
                $0.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Wall
                $0.physicsBody?.mass = 5
                $0.physicsBody?.affectedByGravity = false
                $0.physicsBody?.usesPreciseCollisionDetection = true
        }
    }
    
    fileprivate func configureWorld() {
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
    }
    
    fileprivate func addLabels() {
        lifesLabel.text = "Lifes: \(player.lifes)"
        lifesLabel.zPosition = 100
        lifesLabel.position = CGPoint(x: 0, y: size.height / 2 - lifesLabel.frame.height)
        camera?.addChild(lifesLabel)
        
        enemiesLabel.text = String(format: "Enemies: \(enemies.count)")
        enemiesLabel.zPosition = 100
//        enemiesLabel.fontSize = 17
        enemiesLabel.position = CGPoint(x: size.width / 2 - enemiesLabel.frame.width + 20, y: size.height / 2 - enemiesLabel.frame.height)
        camera?.addChild(enemiesLabel)
    }
    
}
