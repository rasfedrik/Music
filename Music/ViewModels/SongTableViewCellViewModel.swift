//
//  SongTableViewCellViewModel.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//

import Foundation

class SongTableViewCellViewModel {
    
    /// Изображение альбома
    var albumImageView: URL?
    /// Название песни
    var nameSongLabel: String
    
    init(albumImageView: URL?, nameSongLabel: String) {
        self.albumImageView = albumImageView
        self.nameSongLabel = nameSongLabel
    }
    
    /// Получение изображения
    func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let albumImage = albumImageView else { completion(.failure(URLError(.badURL)))
            return
        }
        FetchImage.shared.downloadImage(albumImage, completion: completion)
    }
}

extension SongTableViewCellViewModel: Hashable, Equatable {
    static func == (lhs: SongTableViewCellViewModel, rhs: SongTableViewCellViewModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(albumImageView)
        hasher.combine(nameSongLabel)
    }
}
