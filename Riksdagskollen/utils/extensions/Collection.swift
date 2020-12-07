//
//  Collection.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-04.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
