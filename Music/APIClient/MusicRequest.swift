//
//  MusicRequest.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//

import Foundation

class MusicRequest {
    
    // Первая часть url
    private struct Constants {
        static let baseURL = "https://api.mobimusic.kz"
    }
    
    // Вторая часть url
    private let endpoint: MusicEndpoint
    
    // Формирование url
    private var urlString: String {
        var string = Constants.baseURL
        string += "/\(endpoint.rawValue)"
        return string
    }
    
    /// Полный url
    var url: URL? {
        return URL(string: urlString)
    }
    
    let httpMethod = "GET"
    
    init(
        endpoint: MusicEndpoint
    ){
        self.endpoint = endpoint
    }
    
}

extension MusicRequest {
    static let songDetailRequest = MusicRequest(endpoint: .songDetail)
}
