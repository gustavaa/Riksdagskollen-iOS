//
//  DocumentType.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation

struct DocumentType {

    let docType: String
    let displayName: String
    init(docType: String, displayName: String) {
        self.docType = docType
        self.displayName = displayName
    }
}

struct DocumentTypes {
  
    static let fraga = DocumentType(docType: "fr", displayName: "Skriftliga frågor")
    static let interpellation = DocumentType(docType: "ip", displayName: "Interpellationer")
    static let motion = DocumentType(docType: "mot", displayName: "Motioner")
    static let fragaSvar = DocumentType(docType: "frs", displayName: "Svar på fråga")
    static let betankande = DocumentType(docType: "bet", displayName: "Betänkande")
    static let kamAd = DocumentType(docType: "kma-ad", displayName: "Aktuell Debatt")

    static let values = [fraga, interpellation, motion, fragaSvar, betankande, kamAd]
    
    static func getDocTypeFromDocument(document: PartyDocument) -> DocumentType? {
        return values.first(where: { $0.docType == document.doktyp })
    }
}
