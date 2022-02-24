//
//  CustomErrors.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 24/2/22.
//

import Foundation

enum NetworkingError: Error {
    case badRequest
    case badURL
    case corruptedData
}
