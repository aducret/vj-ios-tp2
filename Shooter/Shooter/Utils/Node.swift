//
//  Node.swift
//  Shooter
//
//  Created by Argentino Ducret on 6/23/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import Foundation
import UIKit

public class Node {
    
    public let walkable: Bool
    public let worldPosition: CGPoint
    
    public init(worldPosition: CGPoint, walkable: Bool = true) {
        self.walkable = walkable
        self.worldPosition = worldPosition
    }
    
}
