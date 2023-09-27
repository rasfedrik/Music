//
//  SongViewController.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//


import UIKit
import AVFoundation

class SongViewController: UIViewController {
    
    /// Collection полученный из MusicListTableView
    var collection: Collection?
    
    /// Массив треков полученный из MusicListTableView
    var track: [Track] = []
    
    /// Изображение альбома полученное из MusicListTableView
    var albumImageView: UIImageView?
    
    /// Индекс нажатой ячейки полученный из MusicListTableView
    var position = 0
    
    /// Массив исполнителей полученный из MusicListTableView
    var singers: [Person] = []
    
    /// Таймер для синхронизации движения слайдера и времени трека
    private var timer: Timer?
    
    /// Массив имён исполнителей
    private var singersName: [String] = []
    
    /// Контейнер для плеера и описания трека
    private var container = ContainerForSongVCView(frame: .zero)
    
    /// Audio player
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .commonColor
        
        audioPlayerConfigure()
        descriptionTreckConfigure()
        
        // Обработка событий после нажатия кнопок плеера
        container.previousTrackButton.addTarget(self, action: #selector(didTapPreviousTrackButton), for: .touchUpInside)
        container.playPouseButton.addTarget(self, action: #selector(didTapPlayPouseButton), for: .touchUpInside)
        container.nextTrackButton.addTarget(self, action: #selector(didTapNextTrackButton), for: .touchUpInside)
        
        container.slider.addTarget(self, action: #selector(sliderAcrion), for: .touchUpInside)
        
        container.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        addContainerConstraints()
        
        // Запуск таймера
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
    }
    
    // Остановка плеера после закрытия ViewController
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioPlayer?.stop()
    }
    
    // MARK: - Actions
    
    /// Cкрыть экран
    @objc private func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    /// Включить предыдущий трек
    @objc private func didTapPreviousTrackButton(_ sender: UIButton) {
        if position > 0 {
            position = position - 1
            audioPlayer?.stop()
            for subview in container.subviews {
                subview.removeFromSuperview()
            }
            
            descriptionTreckConfigure()
            
            audioPlayerConfigure()
            addContainerConstraints()
            
        }
    }
    
    /// Play / pause трека
    @objc private func didTapPlayPouseButton(_ sender: UIButton) {
        container.slider.maximumValue = Float((audioPlayer?.duration ?? 0))
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
            sender.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            audioPlayer?.play()
            sender.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    /// Включить следующий трек
    @objc private func didTapNextTrackButton(_ sender: UIButton) {
        if position < track.count - 1 {
            position = position + 1
            audioPlayer?.stop()
            
            for subview in container.subviews {
                subview.removeFromSuperview()
            }
            
            descriptionTreckConfigure()
            
            audioPlayerConfigure()
            addContainerConstraints()
            
            container.slider.maximumValue = Float((audioPlayer?.duration ?? 0))
        }
    }
    
    /// Скролинг трека
    @objc private func sliderAcrion(_ sender: UISlider) {
        audioPlayer?.stop()
        audioPlayer?.currentTime = TimeInterval(container.slider.value)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
    
    /// Движение слайдера синхронно с временем треком
    @objc private func updateSlider() {
        container.slider.maximumValue = Float((audioPlayer?.duration ?? 0))
        container.slider.value = Float(audioPlayer?.currentTime ?? 0)
        
        if audioPlayer?.isPlaying == false {
            container.playPouseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            container.playPouseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        
    }
    
    /// Заполнение лейблов данными о треке и альбоме
    private func descriptionTreckConfigure() {
        nameSingerLabelText()
        container.albumImageView.image = albumImageView?.image
        container.nameAlbumLabel.text = collection?.album.the234234.name
        container.nameSongLabel.text = track[position].name
    }
    
    /// Заполнение лейбла с именами исполнителей трека
    private func nameSingerLabelText() {
        let singersIDSongs = track[position].peopleIDS
        singersName = []
        for singer in singers {
            for singerID in singersIDSongs {
                if singerID == singer.id {
                    singersName.append(singer.name)
                }
            }
        }
        container.nameSingerLabel.text = singersName.joined(separator: ", ")
    }
    
    /// Настройка аудиоплеера
    private func audioPlayerConfigure() {
        let song = track[position]
        
        guard let urlString = Bundle.main.path(forResource: song.dir, ofType: "mp3") else {
            return }
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let url = URL(string: urlString) else {
                return }
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            audioPlayer?.delegate = self
            
            guard let player = audioPlayer else {
                return }
            
            player.play()
            
        } catch {
            print("error")
        }
    }
    
    /// Выставление констрейнтов для контейнера с плеером и описанием трека
    private func addContainerConstraints() {
        view.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}


// MARK: - AVAudioPlayerDelegate
extension SongViewController: AVAudioPlayerDelegate {
    
    // Отслеживает завершение трека и включает следующий
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            if position < track.count - 1 {
                position = position + 1
                player.stop()
                
                for subview in container.subviews {
                    subview.removeFromSuperview()
                }
                
                audioPlayerConfigure()
                addContainerConstraints()
                
                container.slider.maximumValue = Float(player.duration)
                
                descriptionTreckConfigure()
            }
        }
    }
    
}
