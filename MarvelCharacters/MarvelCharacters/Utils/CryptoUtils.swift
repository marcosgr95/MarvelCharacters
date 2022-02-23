//
//  CryptoUtils.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 23/2/22.
//

import Foundation
import CryptoKit

class CryptoUtils {

    // Singleton pattern
    public static let sharedInstance = CryptoUtils()
    private init() {}

    func MD5(_ string: String) -> String? {
        guard
            let data = string.data(using: .utf8)
        else { return nil}
        return Insecure.MD5.hash(data: data).map{ String(format: "%02hhx", $0)}.joined()
    }
}
