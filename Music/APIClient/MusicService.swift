//
//  MusicService.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//

import Foundation

class MusicService {
    
    static let shared = MusicService()
    
    private init(){}
    
    func execute<T: Codable>(
        _ request: MusicRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ){
        guard let request = request.url
        else { completion(.failure(.init(code: 400, message: "bad request")))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.init(code: 400, message: "failed To Get Data")))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                print(error)
                completion(.failure(Error(code: 400, message: "failed To Get Data")))
            }
        }
        task.resume()
    }
    
    private func request(from musicRequest: MusicRequest) -> URLRequest? {
        guard let url = musicRequest.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = musicRequest.httpMethod
        return request
    }
    
}
