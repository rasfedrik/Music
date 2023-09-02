//
//  SongTableViewCell.swift
//  Music
//
//  Created by Семён Беляков on 30.08.2023.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    static let identifier = "SongTableViewCell"

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var nameSongLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumImageView.image = nil
        nameSongLabel.text = nil
    }
    
    
    func configure(with cellViewModel: SongTableViewCellViewModel) {
        
        nameSongLabel.text = cellViewModel.nameSongLabel
        
        cellViewModel.fetchImage { [weak self] result in
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.albumImageView.image = image
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}
