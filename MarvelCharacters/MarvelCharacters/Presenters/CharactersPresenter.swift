//
//  CharactersPresenter.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 23/2/22.
//

import Foundation
import UIKit

protocol CharactersPresenterDelegate: AnyObject {
    func presentCharacters(characters: [MarvelCharacter])
}

class CharactersPresenter {

    // MARK: - Variables

    weak var view: CharactersPresenterDelegate?

    // MARK: - Public methods

    public func getMarvelCharacters() {
        let ts = "\(Date().timeIntervalSince1970)"

        guard
            let publicKey = BundleUtils.sharedInstance.retrieveString(key: InfoPlistConstants.kMarvelPublicKey),
            let privateKey = BundleUtils.sharedInstance.retrieveString(key: InfoPlistConstants.kMarvelPrivateKey),
            let hash = createHash("\(ts)\(privateKey)\(publicKey)")
        else { return }

        var components = URLComponents(string: NetworkConstants.kCharactersEndpoint)
        components?.queryItems = [
            URLQueryItem(name: NetworkConstants.kApiKeyParam, value: publicKey),
            URLQueryItem(name: NetworkConstants.kTimestampParam, value: ts),
            URLQueryItem(name: NetworkConstants.kHashParam, value: hash),
        ]
        guard let url = components?.url
        else {
            //TODO display/throw error
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                error == nil
            else {
                //TODO display/throw error

                return
            }

            do {
                let responseWrapper = try JSONDecoder().decode(ResponseWrapper.self, from: data)

                self?.view?.presentCharacters(characters: responseWrapper.data.results)
            } catch {
                //TODO display/throw error

                print(error)
            }
        }
        task.resume()

    }

    public func getMarvelCharacter() {

    }

    public func setDelegate(_ delegate: CharactersPresenterDelegate) {
        self.view = delegate
    }

    // MARK: - Private methods

    private func createHash(_ string: String) -> String? {
        return CryptoUtils.sharedInstance.MD5(string)
    }
}
