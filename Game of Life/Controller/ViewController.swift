import UIKit

class ViewController: UIViewController {
    
    var gameTimer: Timer?
    var isGameRunning = false
    var gameOfLifeGrid: Grid!
    let playPauseButton = UIButton()
    let restartButton = UIButton()
    let clearButton = UIButton()
    var countRound = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
     // view.backgroundColor = .systemFill
        view.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.4, alpha: 1.0)
        setupGameOfLifeGrid()
        setupButtonsAndStackView()
    }
    
    func setupGameOfLifeGrid() {
        gameOfLifeGrid = Grid(frame: CGRect(x: 0, y: 0, width: 390, height: 435))
        view.addSubview(gameOfLifeGrid)
        gameOfLifeGrid.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameOfLifeGrid.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameOfLifeGrid.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            gameOfLifeGrid.widthAnchor.constraint(equalToConstant: 390),
            gameOfLifeGrid.heightAnchor.constraint(equalToConstant: 435)
        ])
    }
    
    func setupButtonsAndStackView() {
        // Butonları ayarla
        setupButton(restartButton, title: "Restart", selector: #selector(restartFunc))
        setupButton(playPauseButton, title: "Start", selector: #selector(toggleGameRunning))
        setupButton(clearButton, title: "Clear", selector: #selector(clearFunc))
        
        // Butonları UIStackView içinde grupla
        let stackView = UIStackView(arrangedSubviews: [restartButton, playPauseButton, clearButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack view kısıtlamalarını etkinleştir
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -165),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Buton kurulumunu sadeleştirmek için yardımcı fonksiyon
    func setupButton(_ button: UIButton, title: String, selector: Selector) {
        button.setTitle(title, for: .normal)
    //  button.backgroundColor = .systemBlue
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.75, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.6
        button.addTarget(self, action: selector, for: .touchUpInside)

        // Butona tıklanıldığında renginin koyulaşmasını sağlayacak fonksiyonları ekle
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(didReleaseButton(_:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    
    
    func startGame() {
        isGameRunning = true
        gameTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(performGameStep), userInfo: nil, repeats: true)
        clearButton.backgroundColor = .systemGray
        clearButton.alpha = 0.45
        clearButton.isEnabled = false
        restartButton.backgroundColor = .systemGray
        restartButton.alpha = 0.45
        restartButton.isEnabled = false
    }
    
    func stopGame() {
        isGameRunning = false
        gameTimer?.invalidate()
        gameTimer = nil
  //    clearButton.backgroundColor = .systemBlue
        clearButton.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.75, alpha: 1.0)
        clearButton.alpha = 1.0
        clearButton.isEnabled = true
  //    restartButton.backgroundColor = .systemBlue
        restartButton.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.75, alpha: 1.0)
        restartButton.alpha = 1.0
        restartButton.isEnabled = true
    }
    
    @objc func didTapButton(_ button: UIButton) {
        button.alpha = 0.7 // Koyulaşma efekti
    }

    @objc func didReleaseButton(_ button: UIButton) {
        button.alpha = 1.0 // Normal şeffaflık
    }
    
    @objc func restartFunc(){
        if !isGameRunning{
            
        }
    }
    
    @objc func clearFunc(_ button: UIButton){
        if !isGameRunning{
            gameOfLifeGrid.aliveCells = []
            gameOfLifeGrid.advanceTimeStep()
        }
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
