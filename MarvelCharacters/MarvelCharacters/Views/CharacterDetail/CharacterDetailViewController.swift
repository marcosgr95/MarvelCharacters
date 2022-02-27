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
    @IBOutlet var detailURLButton: UIButton!
    @IBOutlet var wikiURLButton: UIButton!
    @IBOutlet var comicURLButton: UIButton!
    @IBOutlet var appearsInComicsLabel: UILabel!
    @IBOutlet var comicsSV: UIStackView!

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
        configureNavigationBar()
    }

    // MARK: - Style methods

    private func applyStyles() {
        characterLabels.forEach({ $0.font = UIFont.muktaMedium() })
        appearsInComicsLabel.text = "Appears in the following comics:"
    }

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareInfo)
        )
    }

    // MARK: - Private methods

    private func manageLoadingView(show: Bool = true) {
        activityIndicator.isHidden = !show
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        scrollView.isHidden = show
    }

    @objc private func shareInfo() {
        let activityViewController = UIActivityViewController(activityItems: [characterThumbnail.image as Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ .postToFacebook, .addToReadingList, .postToFlickr ]
        self.present(activityViewController, animated: true, completion: nil)

    }

    private func tapLinkButton(_ linkType: MarvelURLWrapper.URLType) {
        do {
            try presenter.showCharacterInBrowser(character, linkType: linkType)
        } catch NetworkingError.noLink {
            //TODO
        } catch NetworkingError.badURL {
            //TODO
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    // MARK: - IBActions

    @IBAction func tapDetailURLButton() {
        tapLinkButton(.detail)
    }

    @IBAction func tapWikiURLButton() {
        tapLinkButton(.wiki)
    }

    @IBAction func tapComicURLButton() {
        tapLinkButton(.comiclink)
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

            if character.comics.isEmpty {
                self.comicsSV.isHidden = true
            } else {
                self.comicsSV.isHidden = false
                for comic in character.comics {
                    let comicLabel = UILabel()
                    comicLabel.font = UIFont.muktaMedium()
                    comicLabel.text = "📚 \(comic)"
                    self.comicsSV.addArrangedSubview(comicLabel)
                }
            }

            guard let thumbnail = character.thumbnail else { return }
            self.characterThumbnail.load(url: thumbnail)

            self.manageLoadingView(show: false)
        }
    }

    func presentError(_ error: NetworkingError) {
        //TODO
    }

}
