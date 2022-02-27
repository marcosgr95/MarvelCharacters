//
//  MarvelCharactersTests.swift
//  MarvelCharactersTests
//
//  Created by Marcos García Rouco on 23/2/22.
//

import XCTest
@testable import MarvelCharacters

class MarvelCharactersTests: XCTestCase {

    func testPresentCharacters() throws {
        let mockPresenter = CharactersPresenterMock(presentUsers: true)
        let mockView = CharactersViewMock()
        mockPresenter.setDelegate(mockView)
        mockPresenter.getMarvelCharacters()
        XCTAssertTrue(mockView.charactersWereSet, "The characters should have been set")
        XCTAssertFalse(mockView.errorWasThrown, "No error should have been thrown")
    }

    func testPresentError() throws {
        let mockPresenter = CharactersPresenterMock(presentUsers: false)
        let mockView = CharactersViewMock()
        mockPresenter.setDelegate(mockView)
        mockPresenter.getMarvelCharacters()
        XCTAssertFalse(mockView.charactersWereSet, "No characters should have been set")
        XCTAssertTrue(mockView.errorWasThrown, "An error should have been thrown")
    }

}

class CharactersPresenterMock: CharactersPresenter {

    private var presentUsers: Bool = true

    init(presentUsers: Bool) {
        self.presentUsers = presentUsers
        super.init()
    }

    override func getMarvelCharacters(initialLoad: Bool = false) {
        presentUsers ? view?.presentCharacters(characters: []) : view?.presentError(NetworkingError.corruptedData)
    }
}

class CharactersViewMock: CharacterListViewController {

    public var charactersWereSet: Bool = false
    public var errorWasThrown: Bool = false

    override func presentCharacters(characters: [MarvelCharacter]) {
        charactersWereSet = true
    }

    override func presentError(_ error: NetworkingError) {
        errorWasThrown = true
    }
}
