//
//  SongView.swift
//  Music
//
//  Created by Семён Беляков on 02.09.2023.
//

import UIKit

class SongView: UIView {
    
    lazy var albumImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameAlbumLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameSongLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameSingerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // Control
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    
    lazy var previousTrackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var playPouseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var nextTrackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constraints()
    }
    
    private func constraints() {
        
        // Description
        addSubview(albumImageView)
        addSubview(nameAlbumLabel)
        addSubview(nameSongLabel)
        addSubview(nameSingerLabel)
        
        NSLayoutConstraint.activate([
            albumImageView.heightAnchor.constraint(equalToConstant: 200),
            albumImageView.widthAnchor.constraint(equalToConstant: 200),
            albumImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            albumImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameAlbumLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 20),
            nameAlbumLabel.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor),
            
            nameSongLabel.topAnchor.constraint(equalTo: nameAlbumLabel.bottomAnchor, constant: 20),
            nameSongLabel.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor),
            
            nameSingerLabel.topAnchor.constraint(equalTo: nameSongLabel.bottomAnchor, constant: 20),
            nameSingerLabel.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor),
            nameSingerLabel.widthAnchor.constraint(equalToConstant: frame.width / 2)
        ])
        
        // Control
        stackView.addArrangedSubview(previousTrackButton)
        stackView.addArrangedSubview(playPouseButton)
        stackView.addArrangedSubview(nextTrackButton)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 80),
            stackView.topAnchor.constraint(equalTo: nameSingerLabel.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        addSubview(slider)
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
    }
    
}
