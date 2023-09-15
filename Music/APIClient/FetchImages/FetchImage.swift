//
//  FetchImage.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//

import UIKit

class FetchImage {
    
    enum FetchImageError: Error {
        case failedToGetData
    }
    
    static let shared = FetchImage()
    
    /// Кэширование изображения
    private let imageDataCashe = NSCache<NSString, NSData>()
    
    private init(){}
    
    /// Получение изображения из URL
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        
        // Проверка наличия изображения в кэше
        if let data = imageDataCashe.object(forKey: key as NSString) {
            completion(.success(data as Data))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        // Получение изображения из сети
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(FetchImageError.failedToGetData))
                return
            }
            
            // Добавление в кэш
            let value = data as NSData
            self?.imageDataCashe.setObject(value, forKey: key)
            
            completion(.success(data))
        }
        task.resume()
    }
}
