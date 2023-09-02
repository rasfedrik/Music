//
//  SongViewController.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//


import UIKit
import AVFoundation

class SongViewController: UIViewController {
    
    var collection: Collection?
    var track: [Track] = []
    var image: UIImage?
    var position = 0
    var persons: [Person] = []
    
    var timer: Timer?
    
    private var singersName: [String] = []
    private var mainView = SongView(frame: .zero)
    
    private var player: AVAudioPlayer?
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configurePlayer()
        configureData()
        
        mainView.previousTrackButton.addTarget(self, action: #selector(didTapPreviousTrackButton), for: .touchUpInside)
        mainView.playPouseButton.addTarget(self, action: #selector(didTapPlayPouseButton), for: .touchUpInside)
        mainView.nextTrackButton.addTarget(self, action: #selector(didTapNextTrackButton), for: .touchUpInside)
        mainView.slider.addTarget(self, action: #selector(sliderAcrion), for: .touchUpInside)
        
        constraints()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.stop()
    }
    
    // Actions
    @objc func didTapPreviousTrackButton(_ sender: UIButton) {
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in mainView.subviews {
                subview.removeFromSuperview()
            }
            nameSingerLabelText()
            mainView.albumImageView.image = image
            mainView.nameAlbumLabel.text = collection?.album.the234234.name
            mainView.nameSongLabel.text = track[position].name
            
            configurePlayer()
            constraints()
            
        }
    }
    
    @objc private func didTapPlayPouseButton(_ sender: UIButton) {
        mainView.slider.maximumValue = Float((player?.duration ?? 0))
        if player?.isPlaying == true {
            player?.pause()
            sender.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            sender.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc private func didTapNextTrackButton(_ sender: UIButton) {
        if position < track.count - 1 {
            position = position + 1
            player?.stop()
            
            for subview in mainView.subviews {
                subview.removeFromSuperview()
            }
            
            nameSingerLabelText()
            mainView.albumImageView.image = image
            mainView.nameAlbumLabel.text = collection?.album.the234234.name
            mainView.nameSongLabel.text = track[position].name
            
            configurePlayer()
            constraints()
            
            mainView.slider.maximumValue = Float((player?.duration ?? 0))
        }
    }
    
    @objc private func sliderAcrion(_ sender: UISlider) {
        player?.stop()
        player?.currentTime = TimeInterval(mainView.slider.value)
        player?.prepareToPlay()
        player?.play()
    }
    
    @objc private func updateSlider() {
        
        mainView.slider.maximumValue = Float((player?.duration ?? 0))
        mainView.slider.value = Float(player?.currentTime ?? 0)
        
        if player?.isPlaying == false {
            mainView.playPouseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            mainView.playPouseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        
    }
    
    private func configureData() {
        nameSingerLabelText()
        mainView.albumImageView.image = image
        mainView.nameAlbumLabel.text = collection?.album.the234234.name
        mainView.nameSongLabel.text = track[position].name
    }
    
    private func nameSingerLabelText() {
        let singersIDSongs = track[position].peopleIDS
        singersName = []
        for singer in persons {
            for singerID in singersIDSongs {
                if singerID == singer.id {
                    singersName.append(singer.name)
                }
            }
        }
        mainView.nameSingerLabel.text = singersName.joined(separator: ", ")
    }
    
    private func configurePlayer() {
        
        let song = track[position]
        
        guard let urlString = Bundle.main.path(forResource: song.dir, ofType: "mp3") else {
            return }
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let url = URL(string: urlString) else {
                return }
            
            player = try AVAudioPlayer(contentsOf: url)
            
            player?.delegate = self
            
            guard let player = player else {
                return }
            
            player.play()
            
        } catch {
            print("error")
        }
    }
    
    private func constraints() {
        view.addSubview(mainView)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension SongViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            if position < track.count - 1 {
                position = position + 1
                player.stop()
                
                for subview in mainView.subviews {
                    subview.removeFromSuperview()
                }
                configurePlayer()
                constraints()
                
                mainView.slider.maximumValue = Float(player.duration)
                
                nameSingerLabelText()
                mainView.albumImageView.image = image
                mainView.nameAlbumLabel.text = collection?.album.the234234.name
                mainView.nameSongLabel.text = track[position].name
            }
        }
    }
    
}
