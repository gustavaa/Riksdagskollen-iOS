//
//  File.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation
import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
}
