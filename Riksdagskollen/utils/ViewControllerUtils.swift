//
//  ViewControllerUtils.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-12.
//

import Foundation
import UIKit

extension UIViewController {
    
    @objc public var backgroundColor : UIColor? {
        set(backgroundColor) { view.backgroundColor = backgroundColor }
        get { return view.backgroundColor }
    }
}
