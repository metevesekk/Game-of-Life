import UIKit
import Foundation

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
}

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



