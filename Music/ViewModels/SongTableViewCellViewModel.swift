//
//  SongTableViewCellViewModel.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//

import Foundation

class SongTableViewCellViewModel {
    
    var albumImageView: URL?
    var nameSongLabel: String
    
    init(albumImageView: URL?, nameSongLabel: String) {
        self.albumImageView = albumImageView
        self.nameSongLabel = nameSongLabel
    }
    
    func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let albumImage = albumImageView else { completion(.failure(Error(code: 400, message: "bad urlImage")))
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
