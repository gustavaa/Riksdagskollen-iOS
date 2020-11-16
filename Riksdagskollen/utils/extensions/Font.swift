//
//  FontUtils.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-08.
//

import Foundation
import UIKit

extension UIFont {

    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }

    func boldItalic() -> UIFont {
        return withTraits(traits: .traitBold, .traitItalic)
    }

}

