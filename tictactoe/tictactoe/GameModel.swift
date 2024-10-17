//
//  GameModel.swift
//  tictactoe
//
//  Created by Jefferson Oliveira de Araujo on 15/10/24.
//

import UIKit

enum Player: String {
    case x = "X"
    case o = "O"
    
    var color: UIColor {
        switch self {
        case .x: return .systemBlue
        case .o: return .systemRed
        }
    }
}

struct GameModel {
    var board: [String?]
    var currentPlayer: Player
    var scoreX: Int = 0
    var scoreO: Int = 0
    var winningLine: [Int]?

    init() {
        board = Array(repeating: nil, count: 9)
        currentPlayer = .x
    }

    mutating func makeMove(at index: Int) -> Bool {
        guard board[index] == nil else { return false }
        board[index] = currentPlayer.rawValue
        currentPlayer = currentPlayer == .x ? .o : .x
        return true
    }

    mutating func checkWinner() -> Player? {
        let winPatterns: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]             // Diagonals
        ]

        for pattern in winPatterns {
            if let player = board[pattern[0]],
               board[pattern[1]] == player,
               board[pattern[2]] == player {
                winningLine = pattern
                return Player(rawValue: player)
            }
        }
        return nil
    }

    func isBoardFull() -> Bool {
        return !board.contains { $0 == nil }
    }

    mutating func updateScore(for player: Player) {
        switch player {
        case .x: scoreX += 1
        case .o: scoreO += 1
        }
    }

    mutating func resetBoard() {
        board = Array(repeating: nil, count: 9)
        currentPlayer = .x
        winningLine = nil
    }
}
