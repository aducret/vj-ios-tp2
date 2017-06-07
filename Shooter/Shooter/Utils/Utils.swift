//
//  Utils.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/11/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import UIKit

public func + (_ vectorA: CGVector, _ vectorB: CGVector) -> CGVector {
    return CGVector(dx: vectorA.dx + vectorB.dx, dy: vectorA.dy + vectorB.dy)
}
