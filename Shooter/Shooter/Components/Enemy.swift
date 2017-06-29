//
//  Enemy.swift
//  Shooter
//
//  Created by Argentino Ducret on 6/15/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

public class Enemy: Player {
    
    public var player: Player!
    fileprivate let enemySpeed = 40
    var path: [Node]? = .none
    fileprivate let breakDistance: CGFloat = 100.0
    fileprivate var currentPlayerPosition =  CGPoint(x: 0, y: 0)
    fileprivate var patrolTarget: CGPoint? = .none
    fileprivate let wanderTime = 5
    
    public enum State {
        case patrolling
        case chasing
        case shotting
    }
    
    public var state: State = .patrolling
    
    public override func updateMovement(byTimeDelta timeDelta: TimeInterval) {
        switch state {
        case .patrolling:
            patrol(byTimeDelta: timeDelta)
        case .chasing:
            chase(byTimeDelta: timeDelta)
        case .shotting:
            shot()
        }
    }
    
}

// Mark: - Private Methods
fileprivate extension Enemy {
    
    fileprivate func patrol(byTimeDelta timeDelta: TimeInterval) {
        guard let scene = scene else { return }
        
        if path == nil || path!.count == 0 {
            let grid = Grid(scene: scene, width: 1800, height: 1800, nodeRadius: 25, collisionBitMask: physicsBody!.collisionBitMask)
            let nodes = grid.grid.flatMap { $0 }.filter { $0.walkable }
            let index = arc4random_uniform(UInt32(nodes.count))
            let origin = grid.nodeFromWorldPoint(point: position).worldPosition
            let target = nodes[Int(index)].worldPosition
            self.path = AStar.findPath(origin: origin, target: target, grid: grid)
        }
        
        if let path = path {
            if path.count > 0 {
                if case animationState = AnimationState.idle {
                    animationState = .walk
                }
                let point = path[0].worldPosition
                let distanceLeft = sqrt(pow(position.x - point.x, 2) + pow(position.y - point.y, 2))
                
                if (distanceLeft > brakeDistance) {
                    let distanceToTravel = CGFloat(timeDelta) * CGFloat(enemySpeed)
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
        
        let distanceToPlayer = sqrt(pow(position.x - player.position.x, 2) + pow(position.y - player.position.y, 2))
        if distanceToPlayer <= 400 {
            state = .chasing
        }
    }
    
    fileprivate func chase(byTimeDelta timeDelta: TimeInterval) {
        guard let scene = scene else { return }
        
        let distance = sqrt(pow(currentPlayerPosition.x - player.position.x, 2) + pow(currentPlayerPosition.y - player.position.y, 2))
        if path == nil || path!.count == 0 || distance >= breakDistance {
            let grid = Grid(scene: scene, width: 1800, height: 1800, nodeRadius: 25, collisionBitMask: physicsBody!.collisionBitMask ^ PhysicsCategory.Player)
            let origin = grid.nodeFromWorldPoint(point: position).worldPosition
            let target = grid.nodeFromWorldPoint(point: player.position).worldPosition
            self.path = AStar.findPath(origin: origin, target: target, grid: grid)
            currentPlayerPosition = player.position
        }
        
        if let path = path {
            if path.count > 0 {
                if case animationState = AnimationState.idle {
                    animationState = .walk
                }
                let point = path[0].worldPosition
                let distanceLeft = sqrt(pow(position.x - point.x, 2) + pow(position.y - point.y, 2))
                
                if (distanceLeft > brakeDistance) {
                    let distanceToTravel = CGFloat(timeDelta) * CGFloat(enemySpeed)
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
        
        let distanceToPlayer = sqrt(pow(position.x - player.position.x, 2) + pow(position.y - player.position.y, 2))
        if distanceToPlayer > 450 {
            state = .patrolling
        } else if distanceToPlayer <= 350 {
            if let bullet = bullet {
                if bullet.parent == .none && isPlayerInSight() {
                    state = .shotting
                }
            } else if isPlayerInSight() {
                state = .shotting
            }
        }
        
    }
    
    fileprivate func shot() {
        shot(to: player.position)
        state = .chasing
    }
    
    fileprivate func isPlayerInSight() -> Bool {
        guard let scene = scene else { return false }
        
        var playerDistance: CGFloat = 0.0
        var nodeDistance: CGFloat = CGFloat.infinity
        var isInSight = false
        scene.physicsWorld.enumerateBodies(alongRayStart: position, end: player.position) { body, point, normal, stop in
            if let node = body.node, node.name ?? "" == "Player" {
                playerDistance = sqrt(pow(self.position.x - self.player.position.x, 2) + pow(self.position.y - self.player.position.y, 2))
                isInSight = true
            }
            
            if let node = body.node, node.name ?? "" == "Wall" {
                let aux = sqrt(pow(self.position.x - node.position.x, 2) + pow(self.position.y - node.position.y, 2))
                if nodeDistance > aux {
                    nodeDistance = aux
                }
            }
            
            if playerDistance <= nodeDistance {
                isInSight = true
            } else {
                isInSight = false
            }
        }
        
        return isInSight
    }
    
}
