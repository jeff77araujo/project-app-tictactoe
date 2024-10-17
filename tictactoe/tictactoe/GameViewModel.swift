//
//  GameViewModel.swift
//  tictactoe
//
//  Created by Jefferson Oliveira de Araujo on 15/10/24.
//

import Foundation

enum GameMode {
    case playerVsPlayer
    case playerVsComputer
}

protocol GameViewModelDelegate: AnyObject {
    func gameStateDidChange()
    func gameDidEnd(winner: Player?, winningLine: [Int]?)
    func scoreDidUpdate()
}

class GameViewModel {
    private var gameModel: GameModel
    weak var delegate: GameViewModelDelegate?
    
    var gameMode: GameMode = .playerVsPlayer
    var playerXName: String = "Player X"
    var playerOName: String = "Player O"

    init() {
        gameModel = GameModel()
    }
    
    func setPlayerNames(playerX: String, playerO: String) {
        playerXName = playerX
        playerOName = playerO
    }

    func makeMove(at index: Int) {
        if gameModel.makeMove(at: index) {
            delegate?.gameStateDidChange()
            checkGameStatus()
            
            if gameMode == .playerVsComputer && gameModel.currentPlayer == .o {
                makeComputerMove()
            }
        }
    }
    
    private func makeComputerMove() {
        let emptyIndices = gameModel.board.enumerated().compactMap { $0.element == nil ? $0.offset : nil }
        if let index = emptyIndices.randomElement() {
            makeMove(at: index)
        }
    }

    func getCellState(at index: Int) -> String? {
        return gameModel.board[index]
    }

    func getCurrentPlayer() -> Player {
        return gameModel.currentPlayer
    }

    private func checkGameStatus() {
        if let winner = gameModel.checkWinner() {
            gameModel.updateScore(for: winner)
            delegate?.scoreDidUpdate()
            delegate?.gameDidEnd(winner: winner, winningLine: gameModel.winningLine)
        } else if gameModel.isBoardFull() {
            delegate?.gameDidEnd(winner: nil, winningLine: nil)
        }
    }

    func resetGame() {
        gameModel.resetBoard()
        delegate?.gameStateDidChange()
    }

    func getScore() -> (x: Int, o: Int) {
        return (gameModel.scoreX, gameModel.scoreO)
    }
}
