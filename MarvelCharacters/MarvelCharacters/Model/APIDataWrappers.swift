//
//  APIDataWrappers.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 23/2/22.
//

import Foundation

struct ResponseWrapper: Decodable {
    var code: Int
    var status: String
    var data: DataWrapper
}

struct DataWrapper: Decodable {
    var results: [MarvelCharacter]
}

struct ItemWrapper: Decodable {
    var name: String
}

struct MarvelURLWrapper: Decodable {
    var type: String
    var url: String

    enum URLType: String {
        case wiki, comiclink, detail
    }
}
