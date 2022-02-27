//
//  MarvelCharacter.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 23/2/22.
//

import Foundation

struct MarvelCharacter: Decodable {

    var id: UInt64
    var name: String
    var descriptionText: String
    var thumbnailPath: String
    var thumbnailExtension: String
    var marvelURLs: [MarvelURLWrapper]
    var comics: [String]
    var series: [String]

    var thumbnail: URL? {
        URL(string: "\(thumbnailPath)/\(NetworkConstants.kStandardLargeThumbnail).\(thumbnailExtension)")
    }

    enum CodingKeys: String, CodingKey {
        // 'Base' coding keys
        case id
        case name
        case descriptionText = "description"
        case marvelURLs = "urls"
        // Thumbnail coding keys
        case thumbnail
        case path
        case `extension`
        // Comics coding keys
        case comics
        case items
        // Series coding keys
        case series
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UInt64.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        descriptionText = try values.decode(String.self, forKey: .descriptionText)
        marvelURLs = try values.decode([MarvelURLWrapper].self, forKey: .marvelURLs)

        let thumbnailWrapper = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnail)
        thumbnailPath = try thumbnailWrapper.decode(String.self, forKey: .path)
        thumbnailPath = thumbnailPath.replacingOccurrences(of: "http://", with: "https://")
        thumbnailExtension = try thumbnailWrapper.decode(String.self, forKey: .`extension`)

        let comicsWrapper = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .comics)
        comics = try comicsWrapper.decode([ItemWrapper].self, forKey: .items).map({ $0.name })

        let seriesWrapper = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .series)
        series = try seriesWrapper.decode([ItemWrapper].self, forKey: .items).map({ $0.name })
    }
    
}
