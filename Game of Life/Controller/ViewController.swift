import UIKit

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
        gameTimer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(performGameStep), userInfo: nil, repeats: true)
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
