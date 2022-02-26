//
//  CharacterDetailViewController.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 26/2/22.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var characterName: UILabel!
    @IBOutlet var characterDescription: UILabel!
    @IBOutlet var characterThumbnail: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var characterLabels: [UILabel]!

    // MARK: - Variables

    var character: MarvelCharacter
    let presenter = CharacterPresenter()

    // MARK: - Init

    init(character: MarvelCharacter) {
        self.character = character
        super.init(nibName: "CharacterDetail", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setDelegate(self)
        manageLoadingView()
        presenter.getMarvelCharacter(String(character.id))
        applyStyles()
    }

    // MARK: - Style methods

    func applyStyles() {
        characterLabels.forEach({ $0.font = UIFont.muktaMedium() })
    }

    // MARK: - Private methods

    func manageLoadingView(show: Bool = true) {
        activityIndicator.isHidden = !show
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        scrollView.isHidden = show
    }

}

extension CharacterDetailViewController: CharacterPresenterDelegate {

    func presentCharacter(_ character: MarvelCharacter?) {
        DispatchQueue.main.async {
            guard let character = character else {
                //TODO
                return
            }
            self.title = character.name
            self.characterName.text = character.name
            self.characterDescription.text = character.descriptionText

            guard let thumbnail = character.thumbnail else { return }
            self.characterThumbnail.load(url: thumbnail)

            self.manageLoadingView(show: false)
        }
    }

    func presentError(_ error: NetworkingError) {
        //TODO
    }

}
