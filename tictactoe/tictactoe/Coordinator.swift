//
//  Coordinator.swift
//  tictactoe
//
//  Created by Jefferson Oliveira de Araujo on 15/10/24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = GameViewModel()
        let vc = GameViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }
}
