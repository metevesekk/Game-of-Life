import UIKit

class ViewController: UIViewController {
    
    var gameTimer: Timer?
    var isGameRunning = false
    var gameOfLifeGrid: Grid!
    let playPauseButton = UIButton()
    let resetButton = UIButton()
    let clearButton = UIButton()
    var countRound = UILabel()
    var initialGameState: Set<Cell> = []
    var sliderOfSpeed = UISlider()
    var sliderOfGridSize = UISlider()
    var speedImageView = UIImageView()
    var sizeImageView = UIImageView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
     // view.backgroundColor = .systemFill
     // view.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.4, alpha: 1.0)
        view.backgroundColor = .white
        setupGameOfLifeGrid()
        setupButtonsAndStackView()
        setupSlidersAndStackView()
        setupImageViewsAndStackView()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
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
    
    func setupSlidersAndStackView() {
        let stackView = UIStackView(arrangedSubviews: [sliderOfSpeed,sliderOfGridSize])
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -75),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setupImageViewsAndStackView() {
        let stackView = UIStackView(arrangedSubviews: [speedImageView,sizeImageView])
        stackView.axis = .vertical
        stackView.spacing = 9
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewWidth: CGFloat = 33 // Örnek genişlik değeri
        let imageViewHeight: CGFloat = 33 // Örnek yükseklik değeri

        speedImageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        speedImageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true

        sizeImageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        sizeImageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
        
        speedImageView.image = UIImage(systemName: "timer")
        sizeImageView.image = UIImage(systemName: "square.grid.3x3")
        speedImageView.tintColor = playPauseButton.backgroundColor
        sizeImageView.tintColor = playPauseButton.backgroundColor
        
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -71),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
          //  stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -280),
        ])
    }
    
    func setupButtonsAndStackView() {
        // Butonları ayarla
        setupButton(resetButton, title: "Restart", selector: #selector(restartFunc))
        setupButton(playPauseButton, title: "Start", selector: #selector(toggleGameRunning))
        setupButton(clearButton, title: "Clear", selector: #selector(clearFunc))
        
        // Butonları UIStackView içinde grupla
        let stackView = UIStackView(arrangedSubviews: [resetButton, playPauseButton, clearButton])
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
    
    func disenableButton(_ button: UIButton){
        button.isEnabled = false
        button.backgroundColor = .systemGray
        button.alpha = 0.45
    }
    
    func enableButton(_ button: UIButton){
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.75, alpha: 1.0)
        button.alpha = 1.0
        button.isEnabled = true
    }
    
    func startGame() {
        isGameRunning = true
        initialGameState = gameOfLifeGrid.aliveCells
        gameTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(performGameStep), userInfo: nil, repeats: true)
        disenableButton(clearButton)
        disenableButton(resetButton)
    }
    
    func stopGame() {
        isGameRunning = false
        gameTimer?.invalidate()
        gameTimer = nil
        enableButton(clearButton)
        enableButton(resetButton)
    }
    
    @objc func didTapButton(_ button: UIButton) {
        button.alpha = 0.7 // Koyulaşma efekti
    }

    @objc func didReleaseButton(_ button: UIButton) {
        button.alpha = 1.0 // Normal şeffaflık
    }
    
    @objc func restartFunc(){
        if !isGameRunning{
            gameOfLifeGrid.aliveCells = initialGameState // Başlangıç durumunu geri yükle
            gameOfLifeGrid.setNeedsDisplay()
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
