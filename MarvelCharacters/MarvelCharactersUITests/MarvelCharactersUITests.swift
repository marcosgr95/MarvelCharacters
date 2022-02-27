//
//  MarvelCharactersUITests.swift
//  MarvelCharactersUITests
//
//  Created by Marcos García Rouco on 23/2/22.
//

import XCTest

class MarvelCharactersUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        app.launch()
        let activityIndicator: XCUIElement = app.activityIndicators[AccessibilityLabels.CharacterList.activityIndicator].firstMatch
        wait(for: [expectation(for: NSPredicate(format: "exists == FALSE"), evaluatedWith: activityIndicator, handler: nil)], timeout: 3)

        continueAfterFailure = false
    }

    func testDifferentResults() throws {
        let charactersTableView: XCUIElement = app.tables[AccessibilityLabels.CharacterList.charactersTableView].firstMatch
        if charactersTableView.cells.count > 1 {
            let firstCellLabel = charactersTableView.cells.element(boundBy: 0).staticTexts.firstMatch.label
            let secondCellLabel = charactersTableView.cells.element(boundBy: 1).staticTexts.firstMatch.label

            XCTAssertNotEqual(firstCellLabel, secondCellLabel, "No two cells should be equal")
        }
    }

    func testCharacterNameRemainsTheSame() throws {
        let charactersTableView: XCUIElement = app.tables[AccessibilityLabels.CharacterList.charactersTableView].firstMatch
        if charactersTableView.cells.count > 0 {
            let firstCell = charactersTableView.cells.element(boundBy: 0).staticTexts.firstMatch
            let firstCellLabel = firstCell.label
            firstCell.tap()

            let detailActivityIndicator: XCUIElement = app.activityIndicators[AccessibilityLabels.CharacterDetail.activityIndicator].firstMatch
            wait(for: [expectation(for: NSPredicate(format: "exists == FALSE"), evaluatedWith: detailActivityIndicator, handler: nil)], timeout: 3)

            let characterName = app.staticTexts[AccessibilityLabels.CharacterDetail.characterName].label
            XCTAssertEqual(firstCellLabel, characterName, "\(firstCellLabel) and \(characterName) aren't equal")
        }
    }

    func testDifferentCharactersHaveDifferentNames() throws {
        let charactersTableView: XCUIElement = app.tables[AccessibilityLabels.CharacterList.charactersTableView].firstMatch
        if charactersTableView.cells.count > 1 {
            let firstCell = charactersTableView.cells.element(boundBy: 0).staticTexts.firstMatch
            let secondCell = charactersTableView.cells.element(boundBy: 1).staticTexts.firstMatch
            let firstCellLabel = firstCell.label
            secondCell.tap()

            let detailActivityIndicator: XCUIElement = app.activityIndicators[AccessibilityLabels.CharacterDetail.activityIndicator].firstMatch
            wait(for: [expectation(for: NSPredicate(format: "exists == FALSE"), evaluatedWith: detailActivityIndicator, handler: nil)], timeout: 3)

            let characterName = app.staticTexts[AccessibilityLabels.CharacterDetail.characterName].label
            XCTAssertNotEqual(firstCellLabel, characterName, "\(firstCellLabel) and \(characterName) shouldn't be equal")
        }
    }

}
