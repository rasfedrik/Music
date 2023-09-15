//
//  MusicService.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//

import Foundation

class MusicService {
    
    enum MusicServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    static let shared = MusicService()
    
    private init(){}
    
    /// Используется для получения данных о треках
    /// - Parameters:
    ///   - request: Экземпляр запроса
    ///   - type: Желаемый тип объекта
    ///   - completion: Завершение
    func execute<T: Codable>(
        _ request: MusicRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ){
        guard let request = request.url
        else { completion(.failure(MusicServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(MusicServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                print(error)
                completion(.failure(MusicServiceError.failedToGetData))
            }
        }
        task.resume()
    }
    
    /// Формирование запроса
    private func request(from musicRequest: MusicRequest) -> URLRequest? {
        guard let url = musicRequest.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = musicRequest.httpMethod
        return request
    }
    
}
