//
//  BundleUtils.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 23/2/22.
//

import Foundation

class BundleUtils {

    // Singleton pattern
    public static let sharedInstance = BundleUtils()
    private init() {}

    public func retrieveString(key: String) -> String? {
        guard
            let mainBundle = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: mainBundle)
        else { return nil}
        return dictionary.object(forKey: key) as? String
    }
}
