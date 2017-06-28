//
//  PathFinding.swift
//  Shooter
//
//  Created by Argentino Ducret on 6/23/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import Foundation
import UIKit

public class AStar {
    
    static func findPath(origin: CGPoint, target: CGPoint, grid: Grid) -> [Node] {
        let startNode = grid.nodeFromWorldPoint(point: origin)
        let targetNode = grid.nodeFromWorldPoint(point: target)
        
        var openSet: [Node] = []
        var closeSet: [Node] = []
        
        openSet.append(startNode)
        
        while openSet.count > 0 {
            
            var currentNode = openSet[0]
            
            for i in 1..<openSet.count {
                if openSet[i].fCost < currentNode.fCost || openSet[i].fCost == currentNode.fCost {
                    if openSet[i].hCost < currentNode.hCost {
                        currentNode = openSet[i]
                    }
                }
            }
            
            openSet = openSet.filter { $0 != currentNode }
            closeSet.append(currentNode)
            
            if currentNode == targetNode {
                return retracePath(startNode: startNode, endNode: targetNode)
            }
            
            for neighbour in grid.getNeighbourds(node: currentNode) {
                if !neighbour.walkable || closeSet.contains(neighbour) {
                    continue
                }
                
                let newCostToNeighbour = currentNode.gCost + getDistance(nodeA: currentNode, nodeB: neighbour)
                if newCostToNeighbour < neighbour.gCost || !openSet.contains(neighbour) {
                    neighbour.gCost = newCostToNeighbour
                    neighbour.hCost = getDistance(nodeA: neighbour, nodeB: targetNode)
                    neighbour.parent = currentNode
                    
                    if !openSet.contains(neighbour) {
                        openSet.append(neighbour)
                    }
                }
            }
        }
    
        return []
    }

}


// MARK: - Private Methods
fileprivate extension AStar {
    
    fileprivate static func retracePath(startNode: Node, endNode: Node) -> [Node] {
        var path: [Node] = []
        var currentNode = endNode
        
        while currentNode != startNode {
            path.append(currentNode)
            currentNode = currentNode.parent
        }
        
        path.reverse()
        
        return path
    }
    
    fileprivate static func getDistance(nodeA: Node, nodeB: Node) -> Int {
        let dstX = abs(nodeA.gridX - nodeB.gridX)
        let dstY = abs(nodeA.gridY - nodeB.gridY)
        
        if dstX > dstY {
            return 14 * dstY + 10 * (dstX - dstY)
        } else {
            return 14 * dstX + 10 * (dstY - dstX)
        }
    }
    
}
