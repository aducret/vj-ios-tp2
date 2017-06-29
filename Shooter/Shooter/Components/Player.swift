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
    public var pointTouched: CGPoint? = .none
    private var path: [Node]? = .none
    
    public enum AnimationState {
        case idle
        case walk
    }
    
    public var animationState: AnimationState = .idle {
        didSet {
            switch animationState {
            case .idle:
                setIdleAnimation()
            case .walk:
                setWalkAnimation()
            }
        }
    }
    
    var bullet: SKSpriteNode? = .none
    
    private let playerSpeed = 80
    let brakeDistance: CGFloat = 5.0
    private var lifes = 3
    
    public func shooted() {
        if lifes > 0 {
            lifes -= 1
        }
        
        if lifes == 0 {
            removeFromParent()
        }
    }
    
    public func updateMovement(byTimeDelta timeDelta: TimeInterval) {
        if let point = pointTouched {
            let enemy = scene!.nodes(at: point).first { $0.name ?? "" == "Enemy"}
            if let enemy = enemy {
                if let bullet = bullet {
                    if bullet.parent == .none {
                        shot(to: enemy.position)
                    }
                } else {
                    shot(to: enemy.position)
                }
                return
            }
        }
        
        if let point = pointTouched {
            let grid = Grid(scene: scene!, width: 1800, height: 1800, nodeRadius: 25, collisionBitMask: physicsBody!.collisionBitMask)
            
            let origin = grid.nodeFromWorldPoint(point: position).worldPosition
            let target = grid.nodeFromWorldPoint(point: point).worldPosition
            path = AStar.findPath(origin: origin, target: target, grid: grid)
            pointTouched = .none
        }
        
        if let path = path {
            if path.count > 0 {
                if case animationState = AnimationState.idle {
                    animationState = .walk
                }
                let point = path[0].worldPosition
                let distanceLeft = sqrt(pow(position.x - point.x, 2) + pow(position.y - point.y, 2))
                
                if (distanceLeft > brakeDistance) {
                    let distanceToTravel = CGFloat(timeDelta) * CGFloat(playerSpeed)
                    let angle = atan2(point.y - position.y, point.x - position.x)
                    let yOffset = distanceToTravel * sin(angle)
                    let xOffset = distanceToTravel * cos(angle)
                    
                    position = CGPoint(x: position.x + xOffset, y: position.y + yOffset)
                    zRotation = CGFloat(Double(angle) - 270.degreesToRadians)
                }
                
                let aux = point - position
                if abs(aux.x) < brakeDistance && abs(aux.y) < brakeDistance {
                    self.path!.remove(at: 0)
                    if self.path!.count == 0 {
                        animationState = .idle
                    }
                }
            }
        }
    }
    
    func shot(to point: CGPoint) {
        let angle = atan2(point.y - position.y, point.x - position.x)
        zRotation = CGFloat(Double(angle) - 270.degreesToRadians)
        
        let texture = SKTexture(imageNamed: "shot")
        let shot = SKSpriteNode(texture: texture, size: CGSize(width: 10, height: 18))
        shot.physicsBody = SKPhysicsBody(rectangleOf: shot.frame.size)
        shot.physicsBody?.categoryBitMask = PhysicsCategory.Shot
        shot.physicsBody?.contactTestBitMask = PhysicsCategory.Wall | PhysicsCategory.Enemy
        shot.physicsBody?.collisionBitMask = 0
        shot.physicsBody?.mass = 5
        shot.physicsBody?.affectedByGravity = false
        shot.physicsBody?.isDynamic = true
        shot.physicsBody?.usesPreciseCollisionDetection = true
        shot.zPosition = 2
        shot.position = convert(children[0].position, to: parent!)
        shot.zRotation = zRotation
        shot.name = "Shot" + name!
        bullet = shot
        parent!.addChild(shot)
        
        let offset = point - shot.position
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + shot.position
        
        let move = SKAction.move(to: realDest, duration: 2.5)
        shot.run(move)
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
    
}
