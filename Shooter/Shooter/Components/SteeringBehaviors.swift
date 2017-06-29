//
//  SteeringBehaviors.swift
//  Shooter
//
//  Created by Argentino Ducret on 6/29/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

protocol Seek {
    
    func seek(target: CGPoint)
    
}

extension Seek where Self: SKNode {
    
    func seek(target: CGPoint) {
        guard let physicsBody = physicsBody else { return }
        
        let curretVelocity = physicsBody.velocity
        let desiredVelocity = (target - position).normalizedVector() * 100
        let steering = desiredVelocity - curretVelocity
        let angle = atan2(target.y - position.y, target.x - position.x)
        zRotation = CGFloat(Double(angle) - 270.degreesToRadians)
        
        physicsBody.applyForce(steering)
    }
    
}
