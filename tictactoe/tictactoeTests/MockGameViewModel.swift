//
//  MockGameViewModel.swift
//  tictactoeTests
//
//  Created by Jefferson Oliveira de Araujo on 17/10/24.
//

@testable import tictactoe

class MockGameViewModel: GameViewModel {
    var lastMoveIndex: Int?
    var resetGameCalled = false

    override func makeMove(at index: Int) {
        lastMoveIndex = index
        super.makeMove(at: index)
    }

    override func resetGame() {
        resetGameCalled = true
        super.resetGame()
    }
}
