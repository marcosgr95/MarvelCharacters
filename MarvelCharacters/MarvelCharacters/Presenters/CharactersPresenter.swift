//
//  CharactersPresenter.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 23/2/22.
//

import Foundation
import UIKit

protocol CharactersPresenterDelegate: AnyObject {
    func notifyRequestStart()
    func presentCharacters(characters: [MarvelCharacter])
    func presentError(_ error: NetworkingError)
}

class CharactersPresenter {

    // MARK: - Variables

    private var endOfData: Bool = false
    private let limit: Int = 20
    private var offset: Int = 0
    private var page: Int = 0
    private var retrievingCharacters: Bool = false
    weak var view: CharactersPresenterDelegate?

    // MARK: - Public methods

    public func getMarvelCharacters(initialLoad: Bool = false) {

        guard !endOfData, !retrievingCharacters else { return }
        retrievingCharacters = true
        view?.notifyRequestStart()

        if initialLoad {
            resetPagination()
        } else {
            addPage()
        }

        let timestamp = "\(Date().timeIntervalSince1970)"

        guard
            let publicKey = BundleUtils.sharedInstance.retrieveString(key: InfoPlistConstants.kMarvelPublicKey),
            let privateKey = BundleUtils.sharedInstance.retrieveString(key: InfoPlistConstants.kMarvelPrivateKey),
            let hash = createHash("\(timestamp)\(privateKey)\(publicKey)")
        else {
            fatalError("The app can't run because there are no valid credentials to retrieve the required data")
        }

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

    public func setDelegate(_ delegate: CharactersPresenterDelegate) {
        self.view = delegate
    }

    // MARK: - Private methods

    private func createHash(_ string: String) -> String? {
        return CryptoUtils.sharedInstance.MD5(string)
    }

    private func addPage() {
        page += 1
        offset += limit * page
    }

    private func resetPagination() {
        page = 0
        offset = 0
    }
}
