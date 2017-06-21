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

public class Enemy: SKSpriteNode {
    
    private var lifes = 3
    
    public func shooted() {
        if lifes > 0 {
            lifes -= 1
        }
        
        if lifes == 0 {
            removeFromParent()
        }
    }
    
}
