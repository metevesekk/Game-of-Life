import UIKit

class ViewController: UIViewController {
    
    var gameTimer: Timer?
    var isGameRunning = false
    var gameOfLifeGrid: Grid!
    let playPauseButton = UIButton()
    let resetButton = UIButton()
    let clearButton = UIButton()
    var countRound = UILabel()
    var Button = Buttons()
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
        stackView.spacing = 9
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        sliderOfSpeed.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(_:)))
            sliderOfSpeed.addGestureRecognizer(tapGestureRecognizer)

        // Slider değerlerini ayarla (örnek değerler, ihtiyacınıza göre değiştirin)
        sliderOfSpeed.minimumValue = 1
        sliderOfSpeed.maximumValue = 45
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -71),
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
        let imageViewWidth: CGFloat = 31 // Örnek genişlik değeri
        let imageViewHeight: CGFloat = 31 // Örnek yükseklik değeri

        speedImageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        speedImageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true

        sizeImageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        sizeImageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
        
        speedImageView.image = UIImage(systemName: "timer")
        sizeImageView.image = UIImage(systemName: "square.grid.2x2")
        speedImageView.tintColor = playPauseButton.backgroundColor
        sizeImageView.tintColor = playPauseButton.backgroundColor
        
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -71),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
        ])
    }
    
    
    func setupButtonsAndStackView() {
        // Butonları ayarla
        Button.setupButton(resetButton, title: "Restart", selector: #selector(restartFunc), target: self)
        Button.setupButton(playPauseButton, title: "Start", selector: #selector(toggleGameRunning), target: self)
        Button.setupButton(clearButton, title: "Clear", selector: #selector(clearFunc), target: self)
        
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
    
    

    
    func startGame() {
        isGameRunning = true
        initialGameState = gameOfLifeGrid.aliveCells

        gameTimer = Timer.scheduledTimer(timeInterval: calculateTimeInterval(from: sliderOfSpeed.value), target: self, selector: #selector(performGameStep), userInfo: nil, repeats: true)

        Button.disenableButton(clearButton)
        Button.disenableButton(resetButton)
    }
    
    func stopGame() {
        isGameRunning = false
        gameTimer?.invalidate()
        gameTimer = nil
        Button.enableButton(clearButton)
        Button.enableButton(resetButton)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        if isGameRunning {
            gameTimer?.invalidate()
            let newTimeInterval = calculateTimeInterval(from: sender.value)
            gameTimer = Timer.scheduledTimer(timeInterval: newTimeInterval, target: self, selector: #selector(performGameStep), userInfo: nil, repeats: true)
        }
    }

    // Kaydırıcının değerini alıp oyun hızına dönüştüren fonksiyon
    func calculateTimeInterval(from sliderValue: Float) -> TimeInterval {
        // Örnek: Slider değeri arttıkça hızın azalmasını istiyorsanız, burada bir hesaplama yapın.
        // Bu sadece bir örnek, gereksinimlerinize göre ayarlayabilirsiniz.
        return TimeInterval(1.0 / sliderValue)
    }
    
  
    
    @objc func sliderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let pointTapped = gestureRecognizer.location(in: self.sliderOfSpeed)

        let widthOfSlider = sliderOfSpeed.frame.size.width
        let newValue = pointTapped.x / widthOfSlider * CGFloat(sliderOfSpeed.maximumValue - sliderOfSpeed.minimumValue) + CGFloat(sliderOfSpeed.minimumValue)

        sliderOfSpeed.setValue(Float(newValue), animated: true)
        sliderValueChanged(sliderOfSpeed) // Değer değiştiğinde ilgili işlevi çağır
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
