//
//  StringUtils.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-10.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        let tmp = htmlToAttributedString?.string ?? ""
        var  result = tmp.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        result = result.replacingOccurrences(of: "&[a-z]+;", with: " ", options: String.CompareOptions.regularExpression, range: nil)
        return result
    }

}
