//
//  Player.swift
//  Shooter
//
//  Created by Argentino Ducret on 6/15/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

public class Player: SKSpriteNode {
    
    public enum State {
        case idle
        case walk
    }
    
    public var state: State = .idle {
        didSet {
            switch state {
            case .idle:
                setIdleAnimation()
            case .walk:
                setWalkAnimation()
            }
        }
    }
    
    public var shooting = false
    
    private let playerSpeed = 80
    private let brakeDistance: CGFloat = 4.0
    private var lifes = 3
    
    public func shooted() {
        if lifes > 0 {
            lifes -= 1
        }
        
        if lifes == 0 {
            removeFromParent()
        }
    }
    
    public func updateMovement(node: SKNode, byTimeDelta timeDelta: TimeInterval) {
        if node.name! == "Enemy" {
            if !shooting {
                shot(to: node.position)
                shooting = true
            }
            return
        }
        
        let point = node.position
        let distanceLeft = sqrt(pow(position.x - point.x, 2) + pow(position.y - point.y, 2))
        
        if (distanceLeft > brakeDistance) {
            let distanceToTravel = CGFloat(timeDelta) * CGFloat(playerSpeed)
            let angle = atan2(point.y - position.y, point.x - position.x)
            let yOffset = distanceToTravel * sin(angle)
            let xOffset = distanceToTravel * cos(angle)
            
            position = CGPoint(x: position.x + xOffset, y: position.y + yOffset)
            zRotation = CGFloat(Double(angle) - 270.degreesToRadians)
        }
    }
    
}

// MARK: Private Methods
fileprivate extension Player {
    
    fileprivate func setWalkAnimation() {
        let animation = SKAction.animate(with: [SKTexture(imageNamed: "player_walk_1"), SKTexture(imageNamed: "player_walk_2"),
                                                SKTexture(imageNamed: "player_walk_3"), SKTexture(imageNamed: "player_walk_4"),
                                                SKTexture(imageNamed: "player_walk_5"), SKTexture(imageNamed: "player_walk_6"),
                                                SKTexture(imageNamed: "player_walk_7"), SKTexture(imageNamed: "player_walk_8")], timePerFrame: 0.1, resize: false, restore: true)
        let repetAnimation = SKAction.repeatForever(animation)
        run(repetAnimation)
    }
    
    fileprivate func setIdleAnimation() {
        removeAllActions()
    }
    
    fileprivate func shot(to point: CGPoint) {
        let angle = atan2(point.y - position.y, point.x - position.x)
        zRotation = CGFloat(Double(angle) - 270.degreesToRadians)
        
        let texture = SKTexture(imageNamed: "shot")
        let shot = SKSpriteNode(texture: texture, size: CGSize(width: 20, height: 35))
        shot.physicsBody = SKPhysicsBody(rectangleOf: shot.frame.size)
        shot.physicsBody?.categoryBitMask = PhysicsCategory.Shot
        shot.physicsBody?.contactTestBitMask = PhysicsCategory.Wall | PhysicsCategory.Enemy
        shot.physicsBody?.collisionBitMask = 0
        shot.physicsBody?.mass = 0.001
        shot.physicsBody?.affectedByGravity = false
        shot.physicsBody?.isDynamic = true
        shot.physicsBody?.usesPreciseCollisionDetection = true
        shot.zPosition = 2
        shot.position = convert(children[0].position, to: parent!)
        shot.zRotation = zRotation
        parent!.addChild(shot)
        
        
        let offset = point - shot.position
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + shot.position
        
        let move = SKAction.move(to: realDest, duration: 2.0)
        shot.run(move)
    }
    
}
