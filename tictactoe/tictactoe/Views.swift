//
//  Views.swift
//  tictactoe
//
//  Created by Jefferson Oliveira de Araujo on 16/10/24.
//

import UIKit

extension UIViewController {

    func showCustomAlert(title: String, message: String, buttonTitle: String, buttonAction: @escaping () -> Void, belowView: UIView) {
        let alertView = UIView()
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 10
        alertView.layer.borderWidth = 1
        alertView.layer.borderColor = UIColor.black.cgColor

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        let actionButton = UIButton(type: .system)
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(alertButtonTapped(_:)), for: .touchUpInside)
        
        // Criar uma UIAction com a closure
        let action = UIAction { _ in
            buttonAction()
            alertView.removeFromSuperview()
        }

        // Adicionar a ação ao botão
        actionButton.addAction(action, for: .touchUpInside)

        // Adiciona os elementos no alerta
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(actionButton)
        
        // Configurar layout usando AutoLayout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        alertView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10),

            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10)
        ])

        view.addSubview(alertView)

        NSLayoutConstraint.activate([
            alertView.topAnchor.constraint(equalTo: belowView.bottomAnchor, constant: 20),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 200),
            alertView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    @objc private func alertButtonTapped(_ sender: UIButton) {
        // Recuperar a ação associada ao botão
        if let action = objc_getAssociatedObject(sender, &AssociatedKeys.buttonActionKey) as? () -> Void {
            action()
        }
        
        // Remover o alerta
        if let alertView = sender.superview {
            UIView.animate(withDuration: 0.3, animations: {
                alertView.alpha = 0
            }, completion: { _ in
                alertView.removeFromSuperview()
            })
        }
    }
}

// Chave associada ao botão para armazenar a ação
private struct AssociatedKeys {
    static var buttonActionKey = "buttonActionKey"
}
