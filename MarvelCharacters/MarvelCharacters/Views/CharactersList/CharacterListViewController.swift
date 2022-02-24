//
//  CharacterListViewController.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 23/2/22.
//

import UIKit

class CharacterListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Variables

    var characters = [MarvelCharacter]()
    let presenter = CharactersPresenter()

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setDelegate(self)
        setUpTableView()
        applyStyles()
        presenter.getMarvelCharacters(initialLoad: true)
    }

    // MARK: - Table methods

    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Styles

    func applyStyles() {
        title = "Marvel Characters"
    }

}

extension CharacterListViewController: CharactersPresenterDelegate {

    func presentCharacters(characters: [MarvelCharacter]) {
        DispatchQueue.main.async {
            self.characters.append(contentsOf: characters)
            self.tableView.reloadData()
        }
    }


}
