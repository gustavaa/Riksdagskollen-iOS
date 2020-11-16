//
//  InfiniteDocumentListModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-13.
//

import Foundation


protocol InfiniteDocumentListModel {
    associatedtype DocumentType
    
    var currentPage: Int { get }
    var documentList: [DocumentType] { get }
    
    func loadNextPage()
}
