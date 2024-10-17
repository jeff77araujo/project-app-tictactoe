//
//  MockGameViewModelDelegate.swift
//  tictactoeTests
//
//  Created by Jefferson Oliveira de Araujo on 17/10/24.
//

@testable import tictactoe

class MockGameViewModelDelegate: GameViewModelDelegate {
    var gameStateDidChangeCalled = false
    var gameDidEndCalled = false
    var scoreDidUpdateCalled = false
    var winningPlayer: Player?
    var winningLine: [Int]?

    func gameStateDidChange() {
        gameStateDidChangeCalled = true
    }

    func gameDidEnd(winner: Player?, winningLine: [Int]?) {
        gameDidEndCalled = true
        winningPlayer = winner
        self.winningLine = winningLine
    }

    func scoreDidUpdate() {
        scoreDidUpdateCalled = true
    }
}
