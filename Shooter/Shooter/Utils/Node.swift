//
//  Node.swift
//  Shooter
//
//  Created by Argentino Ducret on 6/23/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import Foundation
import UIKit

public class Node: Hashable, Equatable {
    
    public static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.worldPosition == rhs.worldPosition
    }
    
    public var hashValue: Int {
        return "\(walkable) \(worldPosition)".hashValue
    }
    
    public let walkable: Bool
    public let worldPosition: CGPoint
    public let gridX: Int
    public let gridY: Int
    
    public var fCost: Int {
        return hCost + gCost
    }
    
    public var hCost: Int = 0
    public var gCost: Int = 0
    public var parent: Node!
    
    public init(worldPosition: CGPoint, walkable: Bool = true, gridX: Int, gridY: Int) {
        self.walkable = walkable
        self.worldPosition = worldPosition
        self.gridX = gridX
        self.gridY = gridY
    }
    
}
