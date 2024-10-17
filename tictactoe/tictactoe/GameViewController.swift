//
//  GameViewController.swift
//  tictactoe
//
//  Created by Jefferson Oliveira de Araujo on 15/10/24.
//

import UIKit

class GameViewController: UIViewController {
    private let viewModel: GameViewModel
    var buttons: [UIButton] = []
    private var scoreLabelX: UILabel!
    private var scoreLabelO: UILabel!
    private var titleLabel: UILabel!
    private var currentPlayerIndicator: UIView!
    private var winningLineView: UIView?
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = DesignSystem.backgroundColor
        
        setupTitleLabel()
        setupCurrentPlayerIndicator()
        setupScoreLabels()
        setupGameBoard()
        setupResetButton()
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Tic Tac Toe"
        
        DesignSystem.styleTitleLabel(titleLabel)
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupCurrentPlayerIndicator() {
        currentPlayerIndicator = UIView()
        currentPlayerIndicator.layer.cornerRadius = 10
        currentPlayerIndicator.backgroundColor = DesignSystem.primaryColor
        
        view.addSubview(currentPlayerIndicator)
        
        currentPlayerIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentPlayerIndicator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            currentPlayerIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentPlayerIndicator.widthAnchor.constraint(equalToConstant: 40),
            currentPlayerIndicator.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupScoreLabels() {
        let scoreView = UIView()
        view.addSubview(scoreView)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        
        scoreLabelX = createScoreLabel(for: .x)
        scoreLabelO = createScoreLabel(for: .o)
        
        scoreView.addSubview(scoreLabelX)
        scoreView.addSubview(scoreLabelO)
        
        NSLayoutConstraint.activate([
            scoreView.topAnchor.constraint(equalTo: currentPlayerIndicator.bottomAnchor, constant: 20),
            scoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scoreView.heightAnchor.constraint(equalToConstant: 30),
            
            scoreLabelX.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor),
            scoreLabelX.centerYAnchor.constraint(equalTo: scoreView.centerYAnchor),
            
            scoreLabelO.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor),
            scoreLabelO.centerYAnchor.constraint(equalTo: scoreView.centerYAnchor)
        ])
        
        updateScoreLabels()
    }
    
    private func createScoreLabel(for player: Player) -> UILabel {
        let label = UILabel()
        DesignSystem.styleScoreLabel(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setupGameBoard() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        for i in 0..<3 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 10
            
            for j in 0..<3 {
                let button = UIButton()
                DesignSystem.styleButton(button)
                button.tag = i * 3 + j
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
                buttons.append(button)
            }
            
            stackView.addArrangedSubview(rowStack)
        }
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scoreLabelX.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    private func setupResetButton() {
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("New Game", for: .normal)
        resetButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
        resetButton.backgroundColor = DesignSystem.primaryColor
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 10
        
        view.addSubview(resetButton)
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        guard let lastButton = buttons.last else { return }
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: lastButton.bottomAnchor, constant: 40),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 120),
            resetButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let currentPlayer = viewModel.getCurrentPlayer()
        animateButtonTap(sender, with: currentPlayer.color)
        viewModel.makeMove(at: sender.tag)
    }
    
    private func animateButtonTap(_ button: UIButton, with color: UIColor) {
        UIView.animate(withDuration: 0.15, animations: {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            button.backgroundColor = color
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                button.transform = .identity
                button.backgroundColor = DesignSystem.accentColor
            }
        }
    }
    
    @objc func resetGame() {
        viewModel.resetGame()
        removeWinningLine()
        animateResetGame()
    }
    
    private func animateResetGame() {
        UIView.animate(withDuration: 0.5, animations: {
            self.buttons.forEach { $0.alpha = 0 }
        }) { _ in
            self.updateUI()
            UIView.animate(withDuration: 0.5) {
                self.buttons.forEach { $0.alpha = 1 }
            }
        }
    }
    
    private func updateUI() {
        for (index, button) in buttons.enumerated() {
            if let cellState = viewModel.getCellState(at: index) {
                button.setTitle(cellState, for: .normal)
                button.setTitleColor(Player(rawValue: cellState)?.color, for: .normal)
                button.isEnabled = false
            } else {
                button.setTitle("", for: .normal)
                button.isEnabled = true
            }
        }
        updateCurrentPlayerIndicator()
    }
    
    private func updateCurrentPlayerIndicator() {
        let currentPlayer = viewModel.getCurrentPlayer()
        UIView.animate(withDuration: 0.3) {
            self.currentPlayerIndicator.backgroundColor = currentPlayer.color
        }
    }
    
    private func updateScoreLabels() {
        let score = viewModel.getScore()
        scoreLabelX.text = "Player X: \(score.x)"
        scoreLabelO.text = "Player O: \(score.o)"
    }
    
    private func animateWinningLine(for winningLine: [Int]) {
        let startButton = buttons[winningLine[0]]
        let endButton = buttons[winningLine[2]]
        
        // Converter as coordenadas dos botões para a view principal
        let startPoint = startButton.superview!.convert(startButton.center, to: self.view)
        let endPoint = endButton.superview!.convert(endButton.center, to: self.view)
        
        let path = UIBezierPath()
        path.move(to: startPoint) // Usar o ponto convertido
        path.addLine(to: endPoint) // Usar o ponto convertido
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = nil
        
        view.layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        
        shapeLayer.add(animation, forKey: "lineAnimation")
        
        winningLineView = UIView()
        winningLineView?.layer.addSublayer(shapeLayer)
        view.addSubview(winningLineView!)
    }

    
    private func removeWinningLine() {
        winningLineView?.removeFromSuperview()
        winningLineView = nil
    }
}

extension GameViewController: GameViewModelDelegate {
    func gameStateDidChange() {
        updateUI()
    }
    
    func gameDidEnd(winner: Player?, winningLine: [Int]?) {
        let message: String
        if let winner = winner {
            message = "Player \(winner.rawValue) wins!"
            if let winningLine = winningLine {
                animateWinningLine(for: winningLine)
            }
        } else {
            message = "It's a draw!"
        }

        if let lastButton = buttons.last {
            showCustomAlert(
                title: "Game Over",
                message: message,
                buttonTitle: "OK",
                buttonAction: {
                    self.resetGame()
                },
                belowView: lastButton
            )
        } else {
            print("Nenhum botão encontrado")
        }
    }
    
    func scoreDidUpdate() {
        updateScoreLabels()
    }
}
