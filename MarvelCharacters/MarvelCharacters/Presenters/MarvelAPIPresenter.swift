//
//  MarvelAPIPresenter.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 26/2/22.
//

import Foundation

class MarvelAPIPresenter {

    private func createHash(_ string: String) -> String? {
        return CryptoUtils.sharedInstance.MD5(string)
    }

    func createMandatoryMarvelAPIParams() -> (String, String, String) {

        let timestamp = "\(Date().timeIntervalSince1970)"

        guard
            let publicKey = BundleUtils.sharedInstance.retrieveString(key: InfoPlistConstants.kMarvelPublicKey),
            let privateKey = BundleUtils.sharedInstance.retrieveString(key: InfoPlistConstants.kMarvelPrivateKey),
            let hash = createHash("\(timestamp)\(privateKey)\(publicKey)")
        else {
            fatalError("The app can't run because there are no valid credentials to retrieve the required data")
        }

        return (publicKey, hash, timestamp)
    }

    public func setDelegate(_ delegate: MarvelAPIDelegate) {}
}
