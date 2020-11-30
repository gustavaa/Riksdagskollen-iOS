//
//  VoteResult.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-26.
//

import Foundation
import SwiftSoup

class VoteResult {
    var voteResults = [String: [Int]]()
    var partiesInVoteList = [String]()
    var total: [Int]? {
        return voteResults["totalt"]
    }
    private let votTableBegin = "<table class=\"vottabell\""
    private let votTableEnd = "</table>"

    
    init(voteResults: [String: [Int]]) {
        self.voteResults = voteResults
    }
    
    init(response: String) {
        let tableBeginIndex = response.index(of: votTableBegin)
        let tableEndIndex = response.index(of: votTableEnd)
        let tablePart = String(response[tableBeginIndex!...tableEndIndex!])
        
        do {
            let document = try SwiftSoup.parse(tablePart)
            let allVotesString = try document.getElementsByClass("vottabell").get(0).text().split(usingRegex: "Frånvarande")[1]
            let allVotesArray = allVotesString.split(usingRegex: " ")
            for index in stride(from: 1, to: allVotesArray.count-5, by: 5) {
                let data = [
                    Int(allVotesArray[index+1]),
                    Int(allVotesArray[index+2]),
                    Int(allVotesArray[index+3]),
                    Int(allVotesArray[index+4]),
                ] as! [Int]
                let label = allVotesArray[index].lowercased()
                voteResults[label] = data
                if label != "totalt" {
                    partiesInVoteList.append(label)
                }
            }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error parsing voteresult html")
        }
    }
    
    func getPartyVotes(party: String) -> [Int]?{
        return voteResults[party.lowercased()]
    }
}
