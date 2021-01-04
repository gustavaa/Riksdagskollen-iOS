//
//  Label.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-30.
//

import Foundation
import UIKit

extension UILabel {
    
    @objc var substituteFontName : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of:"Bold") == nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    
    @objc var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of:"Bold") != nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: 'Cabin', '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        self.attributedText = attrStr
    }
}
