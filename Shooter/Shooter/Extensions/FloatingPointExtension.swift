//
//  FloatingPointExtension.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/10/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

public extension FloatingPoint {
    
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
    
}
