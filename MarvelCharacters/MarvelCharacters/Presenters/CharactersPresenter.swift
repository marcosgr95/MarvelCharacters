//
//  CharactersPresenter.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 23/2/22.
//

import Foundation
import UIKit

protocol MarvelAPIDelegate: AnyObject {
    func presentError(_ error: NetworkingError)
}

protocol CharactersPresenterDelegate: MarvelAPIDelegate {
    func notifyRequestStart()
    func presentDetail(character: MarvelCharacter)
    func presentCharacters(characters: [MarvelCharacter])
}

class CharactersPresenter: MarvelAPIPresenter {

    // MARK: - Variables

    private var endOfData: Bool = false
    private let limit: Int = 20
    private var offset: Int = 0
    private var page: Int = 0
    private var retrievingCharacters: Bool = false
    weak var view: CharactersPresenterDelegate?

    // MARK: - Public methods

    public func getMarvelCharacters(initialLoad: Bool = false) {

        guard !retrievingCharacters else { return }
        retrievingCharacters = true
        view?.notifyRequestStart()

        if initialLoad {
            resetPagination()
        } else {
            addPage()
        }

        guard !endOfData else {
            view?.presentCharacters(characters: [])
            return
        }

        let (publicKey, hash, timestamp) = createMandatoryMarvelAPIParams()

        var components = URLComponents(string: NetworkConstants.kCharactersEndpoint)
        components?.queryItems = [
            URLQueryItem(name: NetworkConstants.kApiKeyParam, value: publicKey),
            URLQueryItem(name: NetworkConstants.kHashParam, value: hash),
            URLQueryItem(name: NetworkConstants.kLimitParam, value: String(limit)),
            URLQueryItem(name: NetworkConstants.kOffsetParam, value: String(offset)),
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

                self?.view?.presentCharacters(characters: responseWrapper.data.results)
                self?.retrievingCharacters = false
                self?.endOfData = responseWrapper.data.results.isEmpty
            } catch {
                self?.view?.presentError(NetworkingError.corruptedData)
            }
        }

        task.resume()
    }

    public func presentDetail(character: MarvelCharacter) {
        view?.presentDetail(character: character)
    }

    // MARK: - Override methods

    override public func setDelegate(_ delegate: MarvelAPIDelegate) {
        self.view = delegate as? CharactersPresenterDelegate
    }

    // MARK: - Private methods

    private func addPage() {
        page += 1
        offset += limit * page
    }

    private func resetPagination() {
        page = 0
        offset = 0
        endOfData = false
    }
}
