//
//  CharacterPresenter.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 26/2/22.
//

import Foundation
import UIKit

protocol CharacterPresenterDelegate: MarvelAPIDelegate {
    func presentCharacter(_ character: MarvelCharacter?)
}

class CharacterPresenter: MarvelAPIPresenter {

    // MARK: - Variables

    weak var view: CharacterPresenterDelegate?

    // MARK: - Public methods

    public func getMarvelCharacter(_ id: String) {

        let (publicKey, hash, timestamp) = createMandatoryMarvelAPIParams()

        var components = URLComponents(string: String(format: NetworkConstants.kCharacterEndpoint, id))
        components?.queryItems = [
            URLQueryItem(name: NetworkConstants.kApiKeyParam, value: publicKey),
            URLQueryItem(name: NetworkConstants.kHashParam, value: hash),
            URLQueryItem(name: NetworkConstants.kTimestampParam, value: timestamp),
        ]
        guard let url = components?.url else {
            self.view?.presentError(NetworkingError.badURL)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                error == nil
            else {
                self?.view?.presentError(NetworkingError.badRequest)
                return
            }

            do {
                let responseWrapper = try JSONDecoder().decode(ResponseWrapper.self, from: data)

                self?.view?.presentCharacter(responseWrapper.data.results.first)
            } catch {
                self?.view?.presentError(NetworkingError.corruptedData)
            }
        }

        task.resume()

    }

    public func showCharacterInBrowser(_ character: MarvelCharacter, linkType: MarvelURLWrapper.URLType) throws {

        guard let selectedURL = character.marvelURLs.filter({ $0.type == linkType.rawValue }).first?.url else {
            throw NetworkingError.noLink
        }

        let (publicKey, hash, timestamp) = createMandatoryMarvelAPIParams()

        var components = URLComponents(string: selectedURL)
        components?.queryItems = [
            URLQueryItem(name: NetworkConstants.kApiKeyParam, value: publicKey),
            URLQueryItem(name: NetworkConstants.kHashParam, value: hash),
            URLQueryItem(name: NetworkConstants.kTimestampParam, value: timestamp),
        ]
        guard let resourceURI = components?.url, UIApplication.shared.canOpenURL(resourceURI) else {
            throw NetworkingError.badURL
        }
        UIApplication.shared.open(resourceURI)
    }

    // MARK: - Override methods

    override public func setDelegate(_ delegate: MarvelAPIDelegate) {
        self.view = delegate as? CharacterPresenterDelegate
    }
}
