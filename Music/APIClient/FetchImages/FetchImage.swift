//
//  FetchImage.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//

import UIKit

class FetchImage {
    
    static let shared = FetchImage()
    
    private let imageDataCashe = NSCache<NSString, NSData>()
    
    private init(){}
    
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        
        if let data = imageDataCashe.object(forKey: key as NSString) {
            completion(.success(data as Data))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(Error(code: 400, message: "failed To Get Data")))
                return
            }
            
            let value = data as NSData
            self?.imageDataCashe.setObject(value, forKey: key)
            
            completion(.success(data))
        }
        task.resume()
    }
}
