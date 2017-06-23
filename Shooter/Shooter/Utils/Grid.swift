//
//  Grid.swift
//  Shooter
//
//  Created by Argentino Ducret on 6/23/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

public class Grid {
    
    private let scene: SKScene
    
    private let width: CGFloat
    private let height: CGFloat
    private let nodeRadius: CGFloat
    private let grid: [[Node]]
    private let collisionBitMask: UInt32
    
    private let nodeDiameter: CGFloat
    private let gridSizeX: UInt
    private let gridSizeY: UInt
    
    public init(scene: SKScene, width: CGFloat, height: CGFloat, nodeRadius: CGFloat, collisionBitMask: UInt32) {
        self.scene = scene
        
        self.width = width
        self.height = height
        self.nodeRadius = nodeRadius
        self.collisionBitMask = collisionBitMask
        
        nodeDiameter = nodeRadius * 2.0
        gridSizeX = UInt(round(width / nodeDiameter))
        gridSizeY = UInt(round(height / nodeDiameter))
        grid = createGrid(gridSizeX: gridSizeX, gridSizeY: gridSizeY, nodeDiameter: nodeDiameter, collisionBitMask: collisionBitMask, scene: scene)
    }
    
    public func nodeFromWorldPoint(worldPosition: CGPoint) -> Node {
        let percentX = min(max((worldPosition.x + width / 2.0) / width, 0), 1)
        let percentY = min(max((worldPosition.y + height / 2.0) / height, 0), 1)
        
        let x = Int(round(CGFloat(gridSizeX - 1) * percentX))
        let y = Int(round(CGFloat(gridSizeY - 1) * percentY))
        
        return grid[x][y]
    }
    
}

private func createGrid(gridSizeX: UInt, gridSizeY: UInt, nodeDiameter: CGFloat, collisionBitMask: UInt32, scene: SKScene) -> [[Node]]{
    let xTop = Int(gridSizeX)
    let yTop = Int(gridSizeY)
    let nodeRadius = nodeDiameter / 2.0
    let repetedValue = Node(worldPosition: CGPoint(x: 0, y: 0))
    var grid = [[Node]](repeating: [Node](repeating: repetedValue, count: xTop), count: yTop)
    let worldBottomLeft = scene.children.filter { $0.name! == "WorldBottomLeft" }[0].position
    
    for x in 0..<xTop {
        for y in 0..<yTop {
            let worldPoint = worldBottomLeft + CGPoint(x: 1, y: 0) * (CGFloat(x) * nodeDiameter + nodeRadius) + CGPoint(x: 0, y: 1) * (CGFloat(y) * nodeDiameter + nodeRadius)
            let walkable = scene.nodes(at: worldPoint).reduce(true) { result, node in
                if let physicsBody = node.physicsBody {
                    return physicsBody.collisionBitMask & collisionBitMask != 0 && result
                } else {
                    return true && result
                }
            }
            grid[x][y] = Node(worldPosition: worldPoint, walkable: walkable)
        }
    }
    
    return grid;
}
