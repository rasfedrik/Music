//
//  SongView.swift
//  Music
//
//  Created by Семён Беляков on 02.09.2023.
//

import UIKit

class ContainerForSongVCView: UIView {
    
    /// Верхний контейнер
    private lazy var containerForDifferentOrientationView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Изображение альбома
    lazy var albumImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// Скрыть экран
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    /// Название альбома
    lazy var nameAlbumLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Название песни
    lazy var nameSongLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(30)
        return label
    }()
    
    /// Имя исполнителя
    lazy var nameSingerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    /// StackView для кнопок previousTrackButton, playPouseButton, nextTrackButton
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    
    /// Предыдущая песня
    lazy var previousTrackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    /// Старт/пауза
    lazy var playPouseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    /// Следующая песня
    lazy var nextTrackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    /// Таймлайн песни
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
    
    // MARK: - Constraints
    
    private func constraints() {
        
        /// Ориентация устройства
        let orientationIsLandscape = UIDevice.current.orientation.isLandscape
        
        // Констрейнты для верхнего контейнера
        addSubview(containerForDifferentOrientationView)
        
        NSLayoutConstraint.activate([
            containerForDifferentOrientationView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            containerForDifferentOrientationView.widthAnchor.constraint(equalTo: widthAnchor),
            containerForDifferentOrientationView.topAnchor.constraint(equalTo: topAnchor),
            containerForDifferentOrientationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerForDifferentOrientationView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        // Удаление объектов с superview
        self.removeFromSuperview(
            albumImageView, nameSongLabel, nameSingerLabel, dismissButton, slider
        )
        // Добавление объектов на superview
        self.addSubviews(
            nameSongLabel, nameSingerLabel, stackView, slider
        )
        
        nameSongLabel.textAlignment = orientationIsLandscape ? .left : .center
        nameSingerLabel.textAlignment = orientationIsLandscape ? .left : .center
        nameAlbumLabel.textAlignment = orientationIsLandscape ? .left : .center
        
        // Добавление объектов на containerForDifferentOrientationView
        containerForDifferentOrientationView.addSubview(albumImageView)
        containerForDifferentOrientationView.addSubview(dismissButton)
        containerForDifferentOrientationView.addSubview(nameAlbumLabel)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            nameAlbumLabel.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            nameAlbumLabel.centerXAnchor.constraint(equalTo: containerForDifferentOrientationView.centerXAnchor)
            ])
        
        if orientationIsLandscape {
            // Горизонтальный режим
            NSLayoutConstraint.activate([
                // Изображение альбома
                albumImageView.heightAnchor.constraint(equalTo: containerForDifferentOrientationView.heightAnchor, multiplier: 0.5),
                albumImageView.widthAnchor.constraint(equalTo: containerForDifferentOrientationView.heightAnchor, multiplier: 0.5),
                albumImageView.topAnchor.constraint(equalTo: nameAlbumLabel.bottomAnchor, constant: 30),
                albumImageView.leadingAnchor.constraint(equalTo: containerForDifferentOrientationView.leadingAnchor, constant: 50),
                
                // Название песни
                nameSongLabel.topAnchor.constraint(equalTo: albumImageView.topAnchor),
                nameSongLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10),
                nameSongLabel.trailingAnchor.constraint(equalTo: containerForDifferentOrientationView.trailingAnchor),
                
                // Имя исполнителя
                nameSingerLabel.topAnchor.constraint(equalTo: nameSongLabel.bottomAnchor),
                nameSingerLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10),
                nameSingerLabel.trailingAnchor.constraint(equalTo: containerForDifferentOrientationView.trailingAnchor)
            ])
            
            // Слайдер
            NSLayoutConstraint.activate([
                slider.topAnchor.constraint(equalTo: containerForDifferentOrientationView.bottomAnchor, constant: 20),
                slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
            
        } else {
            // Вертикальный режим
            NSLayoutConstraint.activate([
                // Изображение альбома
                albumImageView.heightAnchor.constraint(equalTo: containerForDifferentOrientationView.heightAnchor, multiplier: 0.8),
                albumImageView.widthAnchor.constraint(equalTo: containerForDifferentOrientationView.heightAnchor, multiplier: 0.8),
                albumImageView.bottomAnchor.constraint(equalTo: containerForDifferentOrientationView.bottomAnchor),
                albumImageView.centerXAnchor.constraint(equalTo: containerForDifferentOrientationView.centerXAnchor),
                
                // Название песни
                nameSongLabel.topAnchor.constraint(equalTo: containerForDifferentOrientationView.bottomAnchor, constant: 30),
                nameSongLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                nameSongLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

                // Имя исполнителя
                nameSingerLabel.topAnchor.constraint(equalTo: nameSongLabel.bottomAnchor, constant: 10),
                nameSingerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                nameSingerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
            ])
            
            // Слайдер
            NSLayoutConstraint.activate([
                slider.topAnchor.constraint(equalTo: nameSingerLabel.bottomAnchor, constant: 50),
                slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
        }

        // Добавление кнопок управления в stackView
        stackView.addArrangedSubview(previousTrackButton)
        stackView.addArrangedSubview(playPouseButton)
        stackView.addArrangedSubview(nextTrackButton)
        
        // Констрейнты stackView
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.widthAnchor.constraint(equalToConstant: 200),
            stackView.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 50),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}
