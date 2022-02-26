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

    var thumbnail: URL? {
        URL(string: "\(thumbnailPath)/\(NetworkConstants.kStandardLargeThumbnail).\(thumbnailExtension)")
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptionText = "description"
        case thumbnail
        case path
        case `extension`
        case marvelURLs = "urls"
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
    }
    
}
