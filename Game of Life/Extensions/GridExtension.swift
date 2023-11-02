//
//  GridExtension.swift
//  Game of Life
//
//  Created by Mete Vesek on 1.11.2023.
//

import Foundation

extension Grid {
    func setCellAlive (cell: Cell){
        aliveCells.insert(cell)
        setNeedsDisplay()
    }
    
    func setCellDead (cell: Cell){
        aliveCells.remove(cell)
        setNeedsDisplay()
    }
    
   func cellAtPoint(_ Point: CGPoint) -> Cell {
        let x = Int(Point.x/cellSize)
        let y = Int(Point.y/cellSize)
        if aliveCells.contains(where: {$0.x == x && $0.y == y}) {
            return Cell(isAlive: true, x: x, y: y)
        }else{
            return Cell(isAlive: false, x: x, y: y)
        }
    }
    
    func advanceTimeStep() {
        var newAliveCells = Set<Cell>()

        // Önce tüm hücreleri ve onların komşularını bir listeye ekleyelim.
        var allCellsToCheck = Set<Cell>()
        for cell in aliveCells {
            allCellsToCheck.insert(cell)
            allCellsToCheck.formUnion(cell.neighbors)
        }
        
        // Şimdi her hücre için kuralları uygulayalım.
        for cell in allCellsToCheck {
            let livingNeighborsCount = cell.neighbors.filter { neighbor in
                aliveCells.contains(neighbor.copy(isAlive: true))
            }.count
            
            // Hücre canlıysa ve 2 veya 3 canlı komşusu varsa hayatta kalır.
            // Hücre ölüyse ve 3 canlı komşusu varsa canlanır.
            if (aliveCells.contains(cell) && (livingNeighborsCount == 2 || livingNeighborsCount == 3)) || (!aliveCells.contains(cell) && livingNeighborsCount == 3) {
                newAliveCells.insert(cell.copy(isAlive: true))
            }
        }
        
        // Setimizi güncelleyelim.
        aliveCells = newAliveCells
        setNeedsDisplay()
    }


}
