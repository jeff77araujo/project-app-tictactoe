//
//  GameViewModelTests.swift
//  tictactoeTests
//
//  Created by Jefferson Oliveira de Araujo on 17/10/24.
//

import XCTest
@testable import tictactoe

class GameViewModelTests: XCTestCase {
    var viewModel: GameViewModel!
    var delegate: MockGameViewModelDelegate!

    override func setUp() {
        super.setUp()
        viewModel = GameViewModel()
        delegate = MockGameViewModelDelegate()
        viewModel.delegate = delegate
    }

    override func tearDown() {
        viewModel = nil
        delegate = nil
        super.tearDown()
    }

    // Teste para verificar se o estado do jogo muda corretamente após um movimento
    func testMakeMove_updatesGameState() {
        viewModel.makeMove(at: 0)
        
        XCTAssertTrue(delegate.gameStateDidChangeCalled)
    }

    // Teste para verificar se o jogo termina quando há um vencedor
    func testCheckGameStatus_notifiesDelegateWhenGameEndsWithWinner() {
        viewModel.makeMove(at: 0) // Player X
        viewModel.makeMove(at: 1) // Player O
        viewModel.makeMove(at: 3) // Player X
        viewModel.makeMove(at: 4) // Player O
        viewModel.makeMove(at: 6) // Player X (ganha)

        XCTAssertTrue(delegate.gameDidEndCalled)
        XCTAssertEqual(delegate.winningPlayer, .x)
    }

    // Teste para verificar se o jogo termina com empate
    func testCheckGameStatus_notifiesDelegateWhenGameEndsInDraw() {
        viewModel.makeMove(at: 0) // X
        viewModel.makeMove(at: 1) // O
        viewModel.makeMove(at: 2) // X
        viewModel.makeMove(at: 4) // O
        viewModel.makeMove(at: 3) // X
        viewModel.makeMove(at: 5) // O
        viewModel.makeMove(at: 7) // X
        viewModel.makeMove(at: 6) // O
        viewModel.makeMove(at: 8) // X

        XCTAssertTrue(delegate.gameDidEndCalled)
        XCTAssertNil(delegate.winningPlayer)
    }

    // Teste para verificar se o placar é atualizado corretamente
    func testUpdateScore_increasesScoreForWinner() {
        viewModel.makeMove(at: 0) // X
        viewModel.makeMove(at: 1) // O
        viewModel.makeMove(at: 3) // X
        viewModel.makeMove(at: 4) // O
        viewModel.makeMove(at: 6) // X (ganha)

        XCTAssertTrue(delegate.scoreDidUpdateCalled)
        XCTAssertEqual(viewModel.getScore().x, 1)
        XCTAssertEqual(viewModel.getScore().o, 0)
    }

    // Teste para verificar a movimentação do computador no modo Player vs Computer
    func testMakeComputerMove_automaticallyMovesForComputer() {
        viewModel.gameMode = .playerVsComputer

        viewModel.makeMove(at: 0) // Player X move

        XCTAssertTrue(delegate.gameStateDidChangeCalled)
        XCTAssertEqual(viewModel.getCurrentPlayer(), .x) // Após o movimento do computador, deve voltar para o Player X
    }

    // Teste de reset do jogo
    func testResetGame_resetsBoardAndNotifiesDelegate() {
        viewModel.makeMove(at: 0)
        viewModel.resetGame()

        XCTAssertTrue(delegate.gameStateDidChangeCalled)
        XCTAssertNil(viewModel.getCellState(at: 0))
    }
}
