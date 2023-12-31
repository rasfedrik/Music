//
//  HeaderView.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "HeaderView"

    let nameLabel: UILabel = {
        let name = UILabel(frame: .zero)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = name.font.withSize(25)
        name.textColor = .black
        return name
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Добавление констрейнтов
    private func addConstraints() {
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
}
