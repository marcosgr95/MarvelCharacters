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
    @IBOutlet var appearsInSeriesLabel: UILabel!
    @IBOutlet var seriesSV: UIStackView!

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
        setUpAccessibilityIdentifiers()
    }

    // MARK: - Accessibility methods

    private func setUpAccessibilityIdentifiers() {
        activityIndicator.accessibilityIdentifier = AccessibilityLabels.CharacterDetail.activityIndicator
        characterName.accessibilityIdentifier = AccessibilityLabels.CharacterDetail.characterName
    }

    // MARK: - Style methods

    private func applyStyles() {
        view.backgroundColor = StylesConstants.marvelAppMainColor
        scrollView.backgroundColor = StylesConstants.marvelAppMainColor
        characterLabels.forEach { label in
            label.font = UIFont.muktaMedium()
            label.textColor = .white
        }
        appearsInComicsLabel.text = "Appears in the following comics:"
        appearsInSeriesLabel.text = "Appears in the following series:"
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
            showAlert(title: "No link", message: "No \(linkType.humanFriendlyDescription()) was found")
        } catch NetworkingError.badURL {
            showAlert(title: "Bad URL", message: "The URL is corrupt")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    private func displayStringStack(stackView: UIStackView, strings: [String], listIndicator: String) {
        if strings.isEmpty {
            stackView.isHidden = true
        } else {
            stackView.isHidden = false
            for str in strings {
                let customLabel = UILabel()
                customLabel.font = UIFont.muktaMedium()
                customLabel.textColor = .white
                customLabel.text = "\(listIndicator) \(str)"
                customLabel.numberOfLines = 0
                stackView.addArrangedSubview(customLabel)
            }
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
                self.manageLoadingView(show: false)
                self.showAlert(title: "No character", message: "No character detail was found. Try again later.")
                return
            }
            self.title = character.name
            self.characterName.text = character.name
            self.characterDescription.text = character.descriptionText

            self.displayStringStack(stackView: self.comicsSV, strings: character.comics, listIndicator: "📕")
            self.displayStringStack(stackView: self.seriesSV, strings: character.series, listIndicator: "📚")

            self.manageLoadingView(show: false)

            guard let thumbnail = character.thumbnail else { return }
            self.characterThumbnail.load(url: thumbnail)

        }
    }

    func presentError(_ error: NetworkingError) {
        showNetworkingErrorAlert(error)
    }

}
