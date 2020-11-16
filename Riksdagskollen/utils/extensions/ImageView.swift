//
//  ImageView.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-16.
//

import Foundation
import UIKit

extension UIImageView {

    func setImageColor(color: UIColor) {
       let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
       self.image = templateImage
       self.tintColor = color
     }
}
