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
    lazy var paginationOngoingView: UIActivityIndicatorView = {
        return UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
    }()

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
        createRefreshControl()
    }

    // MARK: - Styles

    func applyStyles() {
        title = "Marvel Characters"
    }

    // MARK: - Private methods

    private func createRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc private func handleRefreshControl() {
        characters = []
        tableView.reloadData()
        
        presenter.getMarvelCharacters(initialLoad: true)

        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

}

extension CharacterListViewController: CharactersPresenterDelegate {

    func presentDetail(character: MarvelCharacter) {
        let detailVC = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(detailVC, animated: true)
    }


    func presentCharacters(characters: [MarvelCharacter]) {
        DispatchQueue.main.async {
            self.characters.append(contentsOf: characters)
            self.tableView.reloadData()
            self.paginationOngoingView.stopAnimating()
            self.tableView.tableFooterView = nil
        }
    }

    func notifyRequestStart() {
        DispatchQueue.main.async {
            self.paginationOngoingView.startAnimating()
            self.tableView.tableFooterView = self.paginationOngoingView
        }
    }

    func presentError(_ error: NetworkingError) {
        //TODO show an alert
    }

}
