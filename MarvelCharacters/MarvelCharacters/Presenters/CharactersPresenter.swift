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
    func notifyRequestStart()
}

class CharactersPresenter {

    // MARK: - Variables

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

        let timestamp = "\(Date().timeIntervalSince1970)"

        guard
            let publicKey = BundleUtils.sharedInstance.retrieveString(key: InfoPlistConstants.kMarvelPublicKey),
            let privateKey = BundleUtils.sharedInstance.retrieveString(key: InfoPlistConstants.kMarvelPrivateKey),
            let hash = createHash("\(timestamp)\(privateKey)\(publicKey)")
        else {
            // TODO
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
                self?.retrievingCharacters = false
            } catch {
                //TODO display/throw error

                print(error)
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
