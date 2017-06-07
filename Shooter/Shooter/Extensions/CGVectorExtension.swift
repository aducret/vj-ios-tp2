//
//  CGVectorExtension.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/8/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import Foundation

public extension CGVector {
    
    public func dot(_ vector: CGVector) -> CGFloat {
        return CGFloat(dx * vector.dx + dy * vector.dy)
    }
    
    public func scale(_ value: CGFloat) -> CGVector {
        return CGVector(dx: dx * value, dy: dy * value)
    }
    
    // http://stackoverflow.com/questions/14607640/rotating-a-vector-in-3d-space
    public func rotate(_ angle: CGFloat) -> CGVector {
        return CGVector(dx: dx * cos(angle) - dy * sin(angle), dy: dx * sin(angle) + dy * cos(angle))
    }
    
    public func normalized() -> CGVector {
        let mod = module()
        return CGVector(dx: dx / mod, dy: dy / mod)
    }
    
    public func module() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    public func sum(_ constant: CGFloat) -> CGVector {
        return CGVector(dx: dx + constant, dy: dy + constant)
    }
    
}
