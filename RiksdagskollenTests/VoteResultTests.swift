//
//  VoteResultTests.swift
//  RiksdagskollenTests
//
//  Created by Gustav Aaro on 2020-11-30.
//

import XCTest

@testable import Riksdagskollen
class VoteResultTests: XCTestCase {
    
    var testVoteResult: VoteResult!
    
    override func setUp() {
        /*
            S    97    0    0    16
            M    71    0    0    12
            SD    0    34    0    8
            MP    22    0    0    3
            C    18    0    0    4
            V    20    0    0    1
            L    17    0    0    2
            KD    15    0    0    1
            -    0    3    0    5
            Totalt    260    37    0    52*/
        let resultHTMLTable = "<table class=\"vottabell\" summary='Voteringsresultat'><tr class='sakfragan'><td colspan='5'><h4>Omröstning i sakfrågan</h4><p>Utskottets förslag mot reservation 2 (SD)</p></td></tr><tr class='vottabellrubik'><th>Parti</th><th>Ja</th><th>Nej</th><th>Avstående</th><th>Frånvarande</th></tr><tr><td class='parti'>S</td><td class='rost_ja'>97</td><td class='rost_nej'>0</td><td class='rost_avstar'>0</td><td class='rost_franvarande'>16</td></tr><tr><td class='parti'>M</td><td class='rost_ja'>71</td><td class='rost_nej'>0</td><td class='rost_avstar'>0</td><td class='rost_franvarande'>12</td></tr><tr><td class='parti'>SD</td><td class='rost_ja'>0</td><td class='rost_nej'>34</td><td class='rost_avstar'>0</td><td class='rost_franvarande'>8</td></tr><tr><td class='parti'>MP</td><td class='rost_ja'>22</td><td class='rost_nej'>0</td><td class='rost_avstar'>0</td><td class='rost_franvarande'>3</td></tr><tr><td class='parti'>C</td><td class='rost_ja'>18</td><td class='rost_nej'>0</td><td class='rost_avstar'>0</td><td class='rost_franvarande'>4</td></tr><tr><td class='parti'>V</td><td class='rost_ja'>20</td><td class='rost_nej'>0</td><td class='rost_avstar'>0</td><td class='rost_franvarande'>1</td></tr><tr><td class='parti'>L</td><td class='rost_ja'>17</td><td class='rost_nej'>0</td><td class='rost_avstar'>0</td><td class='rost_franvarande'>2</td></tr><tr><td class='parti'>KD</td><td class='rost_ja'>15</td><td class='rost_nej'>0</td><td class='rost_avstar'>0</td><td class='rost_franvarande'>1</td></tr><tr><td class='parti'>-</td><td class='rost_ja'>0</td><td class='rost_nej'>3</td><td class='rost_avstar'>0</td><td class='rost_franvarande'>5</td></tr><tr><td class='totalt'>Totalt</td><td class='summa_ja'>260</td><td class='summa_nej'>37</td><td class='summa_avstar'>0</td><td class='summa_franvarande'>52</td></tr><tr><td colspan='5'><h4 class='beslut'></h4></td></tr></table>";
        testVoteResult = VoteResult(response: resultHTMLTable)
    }


    func testTotalVotes() throws {
        let correctTotalVotes = [260, 37, 0, 52]
        XCTAssert(correctTotalVotes == testVoteResult.total, "Got \(testVoteResult.total ?? []), expected \(correctTotalVotes)")
    }
    
    func testPartyVotes() throws {
        let correctSVotes = [97, 0,0,16];
        let correctMVotes = [71, 0,0,12];
        let correctSDVotes = [0, 34,0,8];
        let correctMPVotes = [22, 0,0,3];
        let correctCVotes = [18, 0,0,4];
        let correctVVotes = [20, 0,0,1];
        let correctLVotes = [17, 0,0,2];
        let correctKDVotes = [15, 0,0,1];
        XCTAssert(correctSVotes == testVoteResult.getPartyVotes(party: "s"))
        XCTAssert(correctMVotes == testVoteResult.getPartyVotes(party: "m"))
        XCTAssert(correctSDVotes == testVoteResult.getPartyVotes(party: "sd"))
        XCTAssert(correctMPVotes == testVoteResult.getPartyVotes(party: "mp"))
        XCTAssert(correctCVotes == testVoteResult.getPartyVotes(party: "c"))
        XCTAssert(correctVVotes == testVoteResult.getPartyVotes(party: "v"))
        XCTAssert(correctLVotes == testVoteResult.getPartyVotes(party: "l"))
        XCTAssert(correctKDVotes == testVoteResult.getPartyVotes(party: "kd"))
    }
    
    func testPartiesInVoting() throws {
        let correctPartiesInVoting = ["s", "m","sd","mp","c","v","l","kd","-"]
        XCTAssert(correctPartiesInVoting == testVoteResult.partiesInVoteList, "Got \(testVoteResult.partiesInVoteList), expected \(correctPartiesInVoting)")
    }

    
}
