//
//  CustomScrollView.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-04.
//

import Foundation
import UIKit

class CustomScrollView: UIScrollView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
