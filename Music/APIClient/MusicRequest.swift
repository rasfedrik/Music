//
//  MusicRequest.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//

import Foundation

class MusicRequest {
    
    private struct Constants {
        static let baseURL = "https://api.mobimusic.kz"
    }
    
    private let endpoint: MusicEndpoint
    
    private var urlString: String {
        var string = Constants.baseURL
        string += "/\(endpoint.rawValue)"
        return string
    }
    
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
