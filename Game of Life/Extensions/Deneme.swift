

/* import Foundation
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
           var allCellsToCheck = aliveCells
           for cell in aliveCells {
               allCellsToCheck.formUnion(cell.neighbors)
           }
           
           // Şimdi her hücre için kuralları uygulayalım.
           for cell in allCellsToCheck {
               let livingNeighborsCount = cell.neighbors.filter(aliveCells.contains).count
               
               switch livingNeighborsCount {
               case 2:
                   // Eğer bir hücre canlıysa ve iki canlı komşusu varsa, hayatta kalır.
                   if aliveCells.contains(cell) {
                       newAliveCells.insert(cell)
                   }
               case 3:
                   // Eğer bir hücre canlıysa ve üç canlı komşusu varsa, hayatta kalır.
                   // Ayrıca, eğer ölü bir hücrenin tam olarak üç canlı komşusu varsa canlanır.
                   newAliveCells.insert(cell)
               default:
                   // Diğer tüm durumlarda hücre ölür veya ölü kalır.
                   break
               }
           }
           
           // Setimizi güncelleyelim.
           aliveCells = newAliveCells
           setNeedsDisplay()
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
    
    func copy(isAlive: Bool) -> Cell {
        return Cell(isAlive: isAlive, x: self.x, y: self.y)
    }
}


class ViewController: UIViewController {
    
    var gameTimer: Timer?
    var isGameRunning = false
    var gameOfLifeGrid: Grid!
    let playPauseButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Grid setup
        setupGameOfLifeGrid()
        // Play/Pause buton setup
        setupPlayPauseButton()
    }
    
    func setupGameOfLifeGrid() {
        gameOfLifeGrid = Grid(frame: CGRect(x: 0, y: 0, width: 390, height: 435))
        view.addSubview(gameOfLifeGrid)
        gameOfLifeGrid.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameOfLifeGrid.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameOfLifeGrid.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            gameOfLifeGrid.widthAnchor.constraint(equalToConstant: 390),
            gameOfLifeGrid.heightAnchor.constraint(equalToConstant: 435)
        ])
    }

    func setupPlayPauseButton() {
        playPauseButton.setTitle("Start", for: .normal)
        playPauseButton.backgroundColor = .red
        playPauseButton.setTitleColor(UIColor(named: "white"), for: .normal)
        playPauseButton.addTarget(self, action: #selector(toggleGameRunning), for: .touchUpInside)
        
        view.addSubview(playPauseButton)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func startGame() {
        isGameRunning = true
        gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(performGameStep), userInfo: nil, repeats: true)
    }
    
    func stopGame() {
        isGameRunning = false
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    @objc func performGameStep() {
        gameOfLifeGrid.advanceTimeStep()
    }
    
    @objc func toggleGameRunning() {
        if isGameRunning {
            playPauseButton.setTitle("Start", for: .normal)
            stopGame()
        } else {
            playPauseButton.setTitle("Pause", for: .normal)
            startGame()
        }
    }
}


 */
