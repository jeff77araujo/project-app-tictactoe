//
//  GameViewControllerTests.swift
//  tictactoeTests
//
//  Created by Jefferson Oliveira de Araujo on 17/10/24.
//

import XCTest
@testable import tictactoe

class GameViewControllerTests: XCTestCase {
    var viewModel: MockGameViewModel!
    var viewController: GameViewController!

    override func setUp() {
        super.setUp()
        viewModel = MockGameViewModel()
        viewController = GameViewController(viewModel: viewModel)
        viewController.loadViewIfNeeded() // Carrega a view para configurar os elementos UI
    }

    override func tearDown() {
        viewModel = nil
        viewController = nil
        super.tearDown()
    }

    // Teste de inicialização do GameViewController
    func testViewController_initialization() {
        XCTAssertNotNil(viewController)
        XCTAssertEqual(viewModel.delegate as? GameViewController, viewController)
    }

    // Teste para verificar se o botão foi clicado
    func testButtonTapped_sendsMoveToViewModel() {
        let button = UIButton()
        button.tag = 0 // Simulando um botão com tag correspondente à célula 0
        viewController.buttonTapped(button)

        XCTAssertEqual(viewModel.lastMoveIndex, 0)
    }

    // Teste para resetar o jogo
    func testResetButtonTapped_resetsGame() {
        viewController.resetGame()
        XCTAssertTrue(viewModel.resetGameCalled)
    }
}
