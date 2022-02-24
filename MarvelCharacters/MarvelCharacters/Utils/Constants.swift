//
//  Constants.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 23/2/22.
//

import Foundation

struct NetworkConstants {

    public static let kCharactersEndpoint:String = "https://gateway.marvel.com/v1/public/characters"
    public static let kApiKeyParam:String = "apikey"
    public static let kHashParam:String = "hash"
    public static let kLimitParam:String = "limit"
    public static let kOffsetParam:String = "offset"
    public static let kTimestampParam:String = "ts"
    
}

struct InfoPlistConstants {

    public static let kMarvelPublicKey: String = "MARVEL_PUBLIC_KEY"
    public static let kMarvelPrivateKey: String = "MARVEL_PRIVATE_KEY"

}
