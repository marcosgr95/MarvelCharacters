//
//  CharacterPresenter.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 26/2/22.
//

import Foundation

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

    // MARK: - Override methods

    override public func setDelegate(_ delegate: MarvelAPIDelegate) {
        self.view = delegate as? CharacterPresenterDelegate
    }
}
