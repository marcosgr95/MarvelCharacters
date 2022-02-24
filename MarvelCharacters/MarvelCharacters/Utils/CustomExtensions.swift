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
