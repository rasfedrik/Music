//
//  MusicListTableViewController.swift
//  Music
//
//  Created by Семён Беляков on 30.08.2023.
//

import UIKit

class MusicListTableViewController: UITableViewController {
    
    /// Идентификатор таблицы треков
    static let identifier = "MusicListTableView"
    
    /// Индикатор загрузки данных в таблицу
    private lazy var tableActivityIndicator = UIActivityIndicatorView()
    
    /// ImageView для главного изображения альбома
    private var albumImageView: UIImageView?
    
    /// URL изображения альбома
    private var albumImageURL: URL?
    
    /// ViewModel для ячейки таблицы треков
    private var cellViewModel: [SongTableViewCellViewModel] = []

    private var collection: Collection? {
        didSet {
            let album = URL(string: collection?.album.the234234.coverURL ?? "")
            albumImageURL = album
        }
    }
    
    /// Список исполнителей
    private var singers: [Person] = []
    
    /// Список треков
    private var tracks: [Track] = [] {
        didSet {
            for song in tracks {
                let viewModel = SongTableViewCellViewModel(albumImageView: URL(string: song.coverURL), nameSongLabel: song.name)
                
                if !cellViewModel.contains(viewModel) {
                    cellViewModel.append(viewModel)
                }
            }
        }
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Настройка хедера для tableView
        albumImageView = UIImageView(frame: CGRect(
            x: view.center.x,
            y: view.center.x,
            width: 300,
            height: 300
        ))
        
        albumImageView?.contentMode = .scaleAspectFit
        tableView.tableHeaderView = albumImageView
        
        // Запуск индикатора загрузки
        activityIndicatorSettings()
        tableActivityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        
        // Регестрация ячейки таблицы исполнителей и хедера с названием альбома
        tableView.register(UINib.init(nibName: SongTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SongTableViewCell.identifier)
        tableView.register(HeaderView.self,
                           forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        
        // Изменение цвета и оттенка таблицы
        tableView.backgroundColor = .commonColor
        tableView.separatorStyle = .none
        fetchSongs()
    }
    
    /// Настройка индикатора загрузки данных в таблицу
    private func activityIndicatorSettings() {
        tableActivityIndicator = UIActivityIndicatorView(frame: .zero)
        tableActivityIndicator.hidesWhenStopped = true
        tableActivityIndicator.style = .large
        indicatorConstraints()
    }
    
    /// Получение изображения из albumImageURL
    private func fetchImage() {
        guard let albumImageURL = albumImageURL else { return }
        
        FetchImage.shared.downloadImage(albumImageURL) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.albumImageView?.image = UIImage(data: data)
                    
                    self?.tableActivityIndicator.stopAnimating()
                    self?.view.isUserInteractionEnabled = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Получение треков, исполнителей и изображений к трекам
    private func fetchSongs() {
        MusicService.shared.execute(.songDetailRequest, expecting: Music.self) { [weak self] result in
            
            switch result {
            case .success(let song):
                guard let self else { return }
                
                DispatchQueue.main.async {
                    let track = song.collection.track
                    let person = song.collection.people
                    
                    // Заполнение массива со всеми данными
                    self.collection = song.collection
                    
                    // Заполнение массива исполнителей
                    for (_, value) in person {
                        self.singers.append(value)
                    }
                    
                    // Заполнение массива треков
                    for (_, value) in track {
                        self.tracks.append(value)
                    }
                    
                    // Остановка индикатора загрузки данных в таблицу
                    self.tableActivityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    // Получение изображений
                    self.fetchImage()
                    
                    self.tableView.reloadData()
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Констрейнты индикатора загрузки данных в таблицу
    private func indicatorConstraints() {
        tableActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableActivityIndicator)
        
        NSLayoutConstraint.activate([
            tableActivityIndicator.heightAnchor.constraint(equalToConstant: 30),
            tableActivityIndicator.widthAnchor.constraint(equalToConstant: 30),
            tableActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableActivityIndicator.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    // MARK: - TableViewDelegate, TableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    // Настройка хедера с нахванием альбома
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView else { fatalError("header fail") }
        header.nameLabel.text = collection?.album.the234234.name

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

        /// Индекс нажатой ячейки
        let position = indexPath.row
        let vc = SongViewController()

        vc.singers = singers
        vc.collection = collection
        vc.track = tracks
        vc.albumImageView = albumImageView
        vc.position = position
        
        present(vc, animated: true)
    }
    
}
