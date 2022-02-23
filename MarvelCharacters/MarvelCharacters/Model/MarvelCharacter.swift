//
//  MarvelCharacter.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 23/2/22.
//

import Foundation

struct MarvelCharacter: Codable {

    var id: UInt64
    var name: String
    var descriptionText: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptionText = "description"
    }
    
}
