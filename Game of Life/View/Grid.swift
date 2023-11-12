//
//  Grid.swift
//  Game of Life
//
//  Created by Mete Vesek on 1.11.2023.
//

import Foundation
import UIKit

class Grid : UIView {
    var cellSize : CGFloat = 15
    var aliveCells : Set<Cell> = []
    var lastToggledCell: Cell?
    
    override func draw(_ rect: CGRect){
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        //Hücreleri Çizelim
        for y in -1..<Int(bounds.height/cellSize){
            for x in -1..<Int(bounds.width/cellSize){
                let cellRect = CGRect(x: CGFloat(x) * cellSize, y: CGFloat(y) * cellSize, width: cellSize, height: cellSize)
                
                if aliveCells.contains(Cell(isAlive: true, x: x, y: y)) {
                    context.setFillColor(UIColor.black.cgColor)
                } else {
                    context.setFillColor(UIColor.systemYellow.cgColor)
                }
                context.fill(cellRect)
            }
        }
    }
    
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
            
        /*    if aliveCells.contains(where: { cell in
                cell.x == Int((bounds.width/cellSize) - 1)
            }){
                newAliveCells.insert(Cell(isAlive: cell.neighbors.contains { neighbor in
                    neighbor.x == Int(bounds.width/cellSize) && neighbor.y == cell.y
                } , x: 0, y: cell.y))
            }
            
            if aliveCells.contains(where: { cell in
                cell.x == 0
            }){
                newAliveCells.insert(Cell(isAlive: cell.neighbors.contains { neighbor in
                    neighbor.x == -1 && neighbor.y == cell.y
                } , x: Int((bounds.width/cellSize) - 1), y: cell.y))
            }
            
            if aliveCells.contains(where: { cell in
                cell.y == Int((bounds.height/cellSize) - 1)
            }){
                newAliveCells.insert(Cell(isAlive: cell.neighbors.contains { neighbor in
                    neighbor.y == Int(bounds.height/cellSize) && neighbor.x == cell.x
                } , x: cell.x, y: 0))
            }
            
            if aliveCells.contains(where: { cell in
                cell.y == 0
            }){
                newAliveCells.insert(Cell(isAlive: cell.neighbors.contains { neighbor in
                    neighbor.y == -1 && neighbor.x == cell.x
                } , x: cell.x, y: Int((bounds.height/cellSize) - 1)))
            } */
            
        }
        // Setimizi güncelleyelim.
        aliveCells = newAliveCells

        setNeedsDisplay()
    }


        override init(frame: CGRect) {
            super.init(frame: frame)
            setupGestureRecognizers()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupGestureRecognizers()
        } 

        @objc func handleTap(recognizer: UITapGestureRecognizer) {
            let point = recognizer.location(in: self)
            let cell = cellAtPoint(point)

            if aliveCells.contains(cell) {
                setCellDead(cell: cell)
            } else {
                setCellAlive(cell: cell)
            }
        } 
    
    func setupGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapRecognizer)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(panRecognizer)
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: self)
        let cell = cellAtPoint(point)
        
        // Pan hareketi başladığında veya değiştiğinde
        if recognizer.state == .began || recognizer.state == .changed {
            // Eğer geçtiğimiz hücre son değiştirdiğimiz hücre değilse
            if lastToggledCell != cell {
                // Hücrenin mevcut durumunu değiştir
                if aliveCells.contains(cell) {
                    setCellDead(cell: cell)
                } else {
                    setCellAlive(cell: cell)
                }
                // Son değiştirilen hücre olarak kaydet
                lastToggledCell = cell
            }
        }
        
        // Pan hareketi sona erdiğinde son hücreyi sıfırla
        if recognizer.state == .ended {
            lastToggledCell = nil
        }
    }




    }




