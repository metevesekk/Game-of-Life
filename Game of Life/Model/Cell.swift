//
//  Cell.swift
//  Game of Life
//
//  Created by Mete Vesek on 1.11.2023.
//

import Foundation
import UIKit

struct Cell : Hashable {
    
    var isAlive : Bool
    var x : Int
    var y : Int
    
    var neighbors : Set<Cell> {
        var neigborValues = Set<Cell>()
        let offsets : [(Int,Int)] = [(1, 1), (1, 0), (0, 1), (-1, 1), (1, -1), (-1, -1), (0, -1), (-1, 0)]
        for offset in offsets {
            neigborValues.insert(Cell(isAlive: false, x: x + offset.0, y: y + offset.1))
        }
        return neigborValues
        
    }
}
