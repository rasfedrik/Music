//
//  MusicListTableViewController.swift
//  Music
//
//  Created by Семён Беляков on 30.08.2023.
//

import UIKit

class MusicListTableViewController: UITableViewController {
    
    static let identifier = "MusicListTableView"
    
    private lazy var indicator = UIActivityIndicatorView()
    
    private var imageView: UIImageView?
    private var img: UIImage?
    private var albumImageURL: URL?
    private var cellViewModel: [SongTableViewCellViewModel] = []

    
    private var collection: Collection? {
        didSet {
            let album = URL(string: collection?.album.the234234.coverURL ?? "")
            albumImageURL = album
        }
    }
    
    private var persons: [Person] = []
    
    private var songs: [Track] = [] {
        didSet {
            for song in songs {
                let viewModel = SongTableViewCellViewModel(albumImageView: URL(string: song.coverURL), nameSongLabel: song.name)
                
                if !cellViewModel.contains(viewModel) {
                    cellViewModel.append(viewModel)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.style = .navigator
        navigationController?.navigationBar.barTintColor = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imageView = UIImageView(frame: CGRect(
            x: view.center.x,
            y: view.center.x,
            width: 300,
            height: 300
        ))
        
        imageView?.contentMode = .scaleAspectFit
        tableView.tableHeaderView = imageView
        
        activityIndicator()
        indicator.startAnimating()
        view.isUserInteractionEnabled = false
        
        tableView.register(UINib.init(nibName: SongTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SongTableViewCell.identifier)
        tableView.register(HeaderView.self,
                           forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        
        tableView.backgroundColor = .black
        tableView.tintColor = .black
        
        fetchSongs()
        
    }
    
    private func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: .zero)
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicatorConstraints()
    }
    
    private func fetchImage() {
        guard let albumImageURL = albumImageURL else { return }
        
        FetchImage.shared.downloadImage(albumImageURL) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView?.image = UIImage(data: data)
                    self?.img = UIImage(data: data)
                    self?.indicator.stopAnimating()
                    self?.view.isUserInteractionEnabled = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func fetchSongs() {
        MusicService.shared.execute(.songDetailRequest, expecting: Music.self) { [weak self] result in
            
            switch result {
            case .success(let song):
                guard let self else { return }
                
                DispatchQueue.main.async {
                    let track = song.collection.track
                    let person = song.collection.people
                    self.collection = song.collection
                    
                    for (_, value) in person {
                        self.persons.append(value)
                    }
                    
                    for (_, value) in track {
                        self.songs.append(value)
                    }
                    
                    self.indicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.fetchImage()
                    
                    self.tableView.reloadData()
                }
                
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    private func indicatorConstraints() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.heightAnchor.constraint(equalToConstant: 30),
            indicator.widthAnchor.constraint(equalToConstant: 30),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView else { fatalError("header fail") }
        header.nameLabel.text = collection?.album.the234234.name
        
        header.tintColor = .black
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let collection = collection else { return 0 }
        
        return collection.album.the234234.trackCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath) as? SongTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: cellViewModel[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let position = indexPath.row
        let vc = SongViewController()

        vc.persons = persons
        vc.collection = collection
        vc.track = songs
        vc.image = img
        vc.position = position
        
        present(vc, animated: true)
    }
    
}
