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
    
    func split(usingRegex pattern: String) -> [String] {
          //### Crashes when you pass invalid `pattern`
          let regex = try! NSRegularExpression(pattern: pattern)
          let matches = regex.matches(in: self, range: NSRange(0..<utf16.count))
          let ranges = [startIndex..<startIndex] + matches.map{Range($0.range, in: self)!} + [endIndex..<endIndex]
          return (0...matches.count).map {String(self[ranges[$0].upperBound..<ranges[$0+1].lowerBound])}
      }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
