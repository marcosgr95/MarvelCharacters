//
//  CustomExtensions.swift
//  MarvelCharacters
//
//  Created by Marcos García Rouco on 24/2/22.
//

import Foundation
import UIKit

extension UIFont {

    class func muktaMedium() -> UIFont {
        guard
            let redressedRegularFont = UIFont(name: "Mukta-Medium", size: UIFont.labelFontSize)
        else {
            return UIFont.systemFont(ofSize: UIFont.labelFontSize)
        }
        return UIFontMetrics.default.scaledFont(for: redressedRegularFont)
    }
}

extension UIImageView {

    static var defaultImage: UIImage? {
        UIImage(systemName: "photo")?.withTintColor(.lightGray)
    }

    func load(url: URL) {
        self.image = UIImageView.defaultImage
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIViewController {

    public func showAlert(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

    func showNetworkingErrorAlert(_ error: NetworkingError) {
        switch error {
        case .badRequest:
            showAlert(title: "Bad request", message: "No resource matches with what you're trying to retrieve")
        case .badURL:
            showAlert(title: "Bad URL", message: "The URL is corrupt")
        case .corruptedData:
            showAlert(title: "Corrupted data", message: "The data can't be shown because it's corrupted")
        case .noLink:
            showAlert(title: "No link", message: "No link was found")
        }
    }
}
