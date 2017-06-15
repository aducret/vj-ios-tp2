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
    
    private let playerSpeed = 40
    private let brakeDistance: CGFloat = 4.0
    
    public func updateMovement(node: SKNode, byTimeDelta timeDelta: TimeInterval) {
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
