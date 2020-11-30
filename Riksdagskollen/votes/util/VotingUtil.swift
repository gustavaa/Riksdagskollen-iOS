//
//  VotingUtil.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-30.
//

import Foundation


class VotingUtil {
    
    static func createMotionItemsAndCleanup(text: String, motionIds: [String]) -> (String, [MotionDetails]) {
        // Copy text to mutable variable
        var mutableText = String(text)
        var motions = [MotionDetails]()
        var duplicates = 0
        for index in 0..<motionIds.count {
            let motionId = motionIds[index]
            let placeholder = "PLACEHOLDER"
            mutableText = mutableText.stringByReplacingFirstOccurrenceOfString(target: motionId, withString: placeholder)

            guard let beginIndex = mutableText.index(of: placeholder) else { continue }
            var endIndex = mutableText.endIndex
            
            if motionIds.count > index + 1 { // Not last motion
                endIndex = mutableText.index(of: motionIds[index+1])!
            }
            //Cuts out string of interest ex "2017/18:3887 av Martin Kinnunen och Runar Filper (båda SD) yrkande 15 och "
            let relevantSubstring = String(mutableText[beginIndex..<endIndex])
            var keyword = ""
            if relevantSubstring.contains("yrkande") {
                keyword = "yrkande"
            } else {
                keyword = "punkt"
            }
            var replaceString = ""
            var replaceWith = ""
            var proposalPoint = ""
            
            
            if let existingMotion = motions.first(where: {$0.id == motionId}) {
                replaceWith = "[\(existingMotion.listPosition)]"
                duplicates += 1
            } else {
                replaceWith = "[\(index + 1 - duplicates)]"
            }
            
            if relevantSubstring.contains(keyword) {
                print("Relevant:",relevantSubstring)
                let pattern = "\(keyword)[a-z]*\\s[0-9\\soch,-]*[0-9]"
                if relevantSubstring.hasSuffix(", ") {
                    endIndex = relevantSubstring.lastIndex(of: ", ")!
                } else if relevantSubstring.hasSuffix(" och ") {
                    endIndex = relevantSubstring.lastIndex(of: " och ")!
                } else {
                    endIndex = relevantSubstring.endIndexOfFirstRegexMatch(for: pattern)!
                }
                let regexStartIndex = relevantSubstring.beginningIndexOfFirstRegexMatch(for: pattern)!
                let regexEndIndex = relevantSubstring.endIndexOfFirstRegexMatch(for: pattern)!
              
                proposalPoint = String(relevantSubstring[regexStartIndex..<regexEndIndex])
                replaceString = String(relevantSubstring[..<endIndex])
                
                if let existingMotion = motions.first(where: {$0.id == motionId}) {
                    replaceWith = "[\(existingMotion.listPosition)] \(relevantSubstring.groups(for: pattern)[0][0])"
                }
            } else if relevantSubstring.contains(")") {
                endIndex = relevantSubstring.endOfLastIndex(of: ")")!
                replaceString = String(relevantSubstring[..<endIndex])
                proposalPoint = ""
            } else {
                replaceString = placeholder
                proposalPoint = ""
            }
           
            mutableText = mutableText.replacingOccurrences(of: replaceString, with: replaceWith)
            motions.append(MotionDetails(id: motionIds[index], proposalPoint: proposalPoint, listPosition: index + 1 - duplicates))
        }
            
        return (mutableText, motions)
    }
    
    static func getMotionsIds(propositionText: String) -> [String] {
        let pattern = "[0-9]{4}\\/[0-9]{2}:[A-ö]{0,4}[0-9]{0,4}"
        let matches = propositionText.groups(for: pattern)
        return matches.map({$0[0]})
    }
    
    static func boldKeywordsWithHTML(text: String) -> String{
        let keywords = ["avslår", "bifaller", "godkänner"]
        var result = String(text)
        for keyword in keywords {
            result = result.replacingOccurrences(of: keyword, with: "<b>\(keyword)</b>")
        }
        return result
    }
}

struct MotionDetails {
    let id: String
    let proposalPoint: String
    let listPosition: Int
    
    init(id: String, proposalPoint: String, listPosition: Int) {
        self.id = id
        self.proposalPoint = proposalPoint
        self.listPosition = listPosition
    }
}



