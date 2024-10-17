//
//  DesignSystem.swift
//  tictactoe
//
//  Created by Jefferson Oliveira de Araujo on 15/10/24.
//

import UIKit

struct DesignSystem {
    static let primaryColor = UIColor.systemIndigo
    static let secondaryColor = UIColor.systemPink
    static let backgroundColor = UIColor.systemBackground
    static let accentColor = UIColor.systemGray5
    
    static func styleButton(_ button: UIButton) {
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.backgroundColor = accentColor
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
    }
    
    static func styleTitleLabel(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
    }
    
    static func styleScoreLabel(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
    }
}
