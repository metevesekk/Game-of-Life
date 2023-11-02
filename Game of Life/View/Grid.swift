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
    
    override func draw(_ rect: CGRect){
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        //Arkaplanı beyaz yapalım
      //  context.setFillColor(UIColor.white.cgColor)
      //  context.fill(rect)
        
        //Hücreleri Çizelim
        for y in 0..<Int(bounds.height/cellSize){
            for x in 0..<Int(bounds.width/cellSize){
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

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupGestureRecognizers()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupGestureRecognizers()
        } 

        func setupGestureRecognizers() {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.addGestureRecognizer(tapRecognizer)
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

    }




