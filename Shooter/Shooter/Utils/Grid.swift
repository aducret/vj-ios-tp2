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
    public let grid: [[Node]]
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
    
    public func nodeFromWorldPoint(point: CGPoint) -> Node {
        let flattened = grid.flatMap { $0 }
        let node: Node? = flattened.first {
            point.x >= ($0.worldPosition.x - nodeRadius) &&
            point.x <= ($0.worldPosition.x + nodeRadius) &&
            point.y >= ($0.worldPosition.y - nodeRadius) &&
            point.y <= ($0.worldPosition.y + nodeRadius)
        }
        
        return node!
    }
    
    public func getNeighbourds(node: Node) -> [Node] {
        var neighbourds: [Node] = []
        
        for x in -1...1 {
            for y in -1...1 {
                if x == 0 && y == 0 {
                    continue
                }
                
                let checkX = node.gridX + x
                let checkY = node.gridY + y
                if checkX >= 0 && checkX < Int(gridSizeX) && checkY >= 0 && checkY < Int(gridSizeY) {
                    neighbourds.append(grid[checkX][checkY])
                }
            }
        }
        return neighbourds
    }
    
}

private func createGrid(gridSizeX: UInt, gridSizeY: UInt, nodeDiameter: CGFloat, collisionBitMask: UInt32, scene: SKScene) -> [[Node]]{
    let xTop = Int(gridSizeX)
    let yTop = Int(gridSizeY)
    let nodeRadius = nodeDiameter / 2.0
    let repetedValue = Node(worldPosition: CGPoint(x: 0, y: 0), gridX: 0, gridY: 0)
    var grid = [[Node]](repeating: [Node](repeating: repetedValue, count: xTop), count: yTop)
    let worldBottomLeft = scene.children.filter { $0.name ?? "" == "WorldBottomLeft" }[0].position
    
    for x in 0..<xTop {
        for y in 0..<yTop {
            let worldPoint = worldBottomLeft + CGPoint(x: 1, y: 0) * (CGFloat(x) * nodeDiameter + nodeRadius) + CGPoint(x: 0, y: 1) * (CGFloat(y) * nodeDiameter + nodeRadius)
            let walkable = scene.nodes(at: worldPoint).reduce(true) { result, node in
                if let physicsBody = node.physicsBody {
                    return physicsBody.categoryBitMask & collisionBitMask == 0 && result
                } else {
                    return result
                }
            }
            grid[x][y] = Node(worldPosition: worldPoint, walkable: walkable, gridX: x, gridY: y)
        }
    }
    
    return grid;
}
