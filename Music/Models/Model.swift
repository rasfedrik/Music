//
//  Model.swift
//  Music
//
//  Created by Семён Беляков on 31.08.2023.
//

import Foundation

// MARK: - Music
struct Music: Codable {
//    let error: Error
//    let response: Response
    let collection: Collection
}

// MARK: - Collection
struct Collection: Codable {
    let album: Album
    let track: [String: Track]
    let people: [String: Person]
}

// MARK: - Album
struct Album: Codable {
    let the234234: The234234

    enum CodingKeys: String, CodingKey {
        case the234234 = "234234"
    }
}

// MARK: - The234234
struct The234234: Codable {
    let id: String
    let name, cover: String
    let coverURL: String
    let dir: String
    let peopleIDS: [String]
    let duration, trackCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, cover
        case coverURL = "coverUrl"
        case dir
        case peopleIDS = "peopleIds"
        case duration, trackCount
    }
}


// MARK: - Person
struct Person: Codable {
    let id, name, dir: String
    let coverURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name, dir
        case coverURL = "coverUrl"
    }
}

// MARK: - Track
struct Track: Codable {
    let id, parent, name, cover: String
    let coverURL: String
    let dir: String
    let peopleIDS: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, parent, name, cover
        case coverURL = "coverUrl"
        case dir
        case peopleIDS = "peopleIds"
    }
}
