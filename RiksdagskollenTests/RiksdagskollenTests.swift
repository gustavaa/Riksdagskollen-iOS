//
//  RiksdagskollenTests.swift
//  RiksdagskollenTests
//
//  Created by Gustav Aaro on 2020-11-30.
//

import XCTest
import UIKit
@testable import Riksdagskollen

class VotingUtilTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testMotionIdsExtraction1() throws {
        let decisionText = "Riksdagen avslår motion 2020/21:3729 av Johan Forssell m.fl. (M) yrkande 5."
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let expected = ["2020/21:3729"]
        XCTAssert(motionIds == expected, "Got \(motionIds), expected \(expected)")
    }
    
    func testMotionIdsExtraction2() throws {
        let decisionText = "Riksdagen avslår motionerna 2020/21:47 av Martina Johansson (C) yrkandena 1 och 2, 2020/21:216 av Lars Thomsson (C), 2020/21:274 av Ann-Christine From Utterstedt m.fl. (SD), 2020/21:376 av Björn Söder (SD), 2020/21:601 av Josef Fransson (SD) yrkande 11, 2020/21:2346 av Boriana Åberg (M), 2020/21:3343 av Ann-Christine From Utterstedt (SD) och 2020/21:3417 av Markus Wiechel m.fl. (SD) yrkandena 1-4 och lägger skrivelse 2019/20:180 till handlingarna."
        
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let expected = ["2020/21:47","2020/21:216","2020/21:274", "2020/21:376", "2020/21:601", "2020/21:2346", "2020/21:3343", "2020/21:3417","2019/20:180"]
        XCTAssert(motionIds == expected, "Got \(motionIds), expected \(expected)")
    }
    
    func testMotionIdsExtraction3() throws {
        let decisionText = "Riksdagen antar regeringens förslag till 1. lag om ändring i lagen (2000:344) om Schengens informationssystem, 2. lag om ändring i utlänningslagen (2005:716). Därmed bifaller riksdagen proposition 2020/21:6 punkterna 1 och 2 samt avslår motion 2020/21:452 av Linda Westerlund Snecker m.fl. (V)."
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let expected = ["2020/21:6","2020/21:452"]
        XCTAssert(motionIds == expected, "Got \(motionIds), expected \(expected)")
    }
    
    func testCreateMotionItems1() throws {
        let decisionText = "Riksdagen avslår motion 2020/21:3729 av Johan Forssell m.fl. (M) yrkande 5."
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let cleanedUpText = VotingUtil.createMotionItemsAndCleanup(text: decisionText, motionIds: motionIds).0
        let expected = "Riksdagen avslår motion [1]."
        XCTAssert(cleanedUpText == expected, "Got \(cleanedUpText), expected \(expected)")
    }
    
    func testCreateMotionItems2() throws {
        let decisionText = "Riksdagen antar regeringens förslag till lag om ändring i utlänningsdatalagen (2016:27). Därmed bifaller riksdagen proposition 2020/21:5 och avslår motion 2020/21:399 av Christina Höj Larsen m.fl. (V) yrkande 1."
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let cleanedUpText = VotingUtil.createMotionItemsAndCleanup(text: decisionText, motionIds: motionIds).0
        let expected = "Riksdagen antar regeringens förslag till lag om ändring i utlänningsdatalagen (2016:27). Därmed bifaller riksdagen proposition [1] och avslår motion [2]."
        XCTAssert(cleanedUpText == expected, "Got \(cleanedUpText), expected \(expected)")
    }
    
    func testCreateMotionItems3() throws {
        let decisionText = "Riksdagen avslår motionerna 2020/21:145 av Maria Malmer Stenergard m.fl. (M, KD) yrkandena 1, 2, 4 och 5, 2020/21:306 av Christina Höj Larsen m.fl. (V) yrkande 3 och 2020/21:3642 av Maria Malmer Stenergard m.fl. (M) yrkandena 8 och 9 samt lägger skrivelse 2019/20:191 till handlingarna."
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let cleanedUpText = VotingUtil.createMotionItemsAndCleanup(text: decisionText, motionIds: motionIds).0
        let expected = "Riksdagen avslår motionerna [1], [2] och [3] samt lägger skrivelse [4] till handlingarna."
        XCTAssert(cleanedUpText == expected, "Got \(cleanedUpText), expected \(expected)")
    }
    
    func testCreateMotionItems4() throws {
        let decisionText = "Riksdagen godkänner de riktlinjer för den ekonomiska politiken och budgetpolitiken som regeringen föreslår. Därmed bifaller riksdagen proposition 2020/21:1 finansplanen punkt 1 och avslår motionerna"
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let cleanedUpText = VotingUtil.createMotionItemsAndCleanup(text: decisionText, motionIds: motionIds).0
        let expected = "Riksdagen godkänner de riktlinjer för den ekonomiska politiken och budgetpolitiken som regeringen föreslår. Därmed bifaller riksdagen proposition [1] och avslår motionerna"
        XCTAssert(cleanedUpText == expected, "Got \(cleanedUpText), expected \(expected)")
    }
    func testCreateMotionItems5() throws {
        let decisionText = "Utskottets förslag: Ändrade ramar för utgiftsområden och ändrade och nya anslag Riksdagen godkänner ändrade ramar för utgiftsområden och anvisar ändrade och nya anslag enligt utskottets förslag i bilaga 3. Därmed bifaller riksdagen delvis proposition 2019/20:187 punkt 8 och avslår motionerna 2019/20:3647 av Jakob Forssmed m.fl. (KD) och 2019/20:3648 av Elisabeth Svantesson m.fl. (M) yrkande 1."
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let cleanedUpText = VotingUtil.createMotionItemsAndCleanup(text: decisionText, motionIds: motionIds).0
        let expected = "Utskottets förslag: Ändrade ramar för utgiftsområden och ändrade och nya anslag Riksdagen godkänner ändrade ramar för utgiftsområden och anvisar ändrade och nya anslag enligt utskottets förslag i bilaga 3. Därmed bifaller riksdagen delvis proposition [1] och avslår motionerna [2] och [3]."
        XCTAssert(cleanedUpText == expected, "Got \(cleanedUpText), expected \(expected)")
    }
    
    func testCreateMotionItems6() throws {
        let decisionText = "Utskottets förslag: Ändrade ramar för utgiftsområden och ändrade och nya anslag Riksdagen godkänner ändrade ramar för utgiftsområden och anvisar ändrade och nya anslag enligt utskottets förslag i bilaga 3. Därmed bifaller riksdagen delvis proposition 2019/20:187 punkt 8 och avslår motionerna 2019/20:3647 av Jakob Forssmed m.fl. (KD) och 2019/20:3648 av Elisabeth Svantesson m.fl. (M) yrkande 1. Utgiftsområde 9 Hälsovård, sjukvård och social omsorg Riksdagen a) bemyndigar regeringen att under 2020 som beredskapsinvestering ingå avtal om vaccin mot covid-19, b) bemyndigar regeringen att för 2020 besluta att Folkhälsomyndigheten får ta upp lån i Riksgäldskontoret för beredskapsinvesteringar som inklusive tidigare upplåning uppgår till högst 2 000 000 000 kronor. Därmed bifaller riksdagen proposition 2019/20:187 punkterna 1 och 2 samt avslår motion 2019/20:3648 av Elisabeth Svantesson m.fl. (M) yrkande 2. Utgiftsområde 22 Kommunikationer Riksdagen godkänner den föreslagna användningen av anslaget 1:6 Ersättning avseende icke statliga flygplatser inom utgiftsområde 22 Kommunikationer. Därmed bifaller riksdagen proposition 2019/20:187 punkt 3 och avslår motion 2019/20:3646 av Jonas Sjöstedt m.fl. (V) yrkande 3. Utgiftsområde 24 Näringsliv Riksdagen a) bemyndigar regeringen att under 2020 för anslaget 1:17 Kapitalinsatser i statliga ägda företag för statens räkning förvärva aktier eller andelar eller vidta andra liknande åtgärder som syftar till att rekapitalisera SAS AB med ett belopp om högst 5 000 000 000 kronor och inom denna ram öka statens röst- och ägarandel i bolaget, b) bemyndigar regeringen att vidta de övriga åtgärder som är nödvändiga för att möjliggöra statens deltagande i en rekapitalisering av SAS AB, c) bemyndigar regeringen att under 2020 för anslaget 1:17 Kapitalinsatser i statliga ägda företag inom utgiftsområde 24 Näringsliv besluta om kapitaltillskott på högst 3 150 000 000 kronor till Swedavia AB, d) bemyndigar regeringen att under 2020 för anslaget 1:17 Kapitalinsatser i statliga ägda företag inom utgiftsområde 24 Näringsliv besluta om kapitaltillskott på högst 150 000 000 kronor till Lernia AB, e) ställer sig bakom det som utskottet anför om Arlandas framtid och tillkännager detta för regeringen. Därmed bifaller riksdagen proposition 2019/20:187 punkterna 4-7, bifaller delvis motionerna 2019/20:3645 av Oscar Sjöstedt m.fl. (SD) yrkande 2 och 2019/20:3648 av Elisabeth Svantesson m.fl. (M) yrkande 3 och avslår motionerna 2019/20:3645 av Oscar Sjöstedt m.fl. (SD) yrkande 1 och 2019/20:3646 av Jonas Sjöstedt m.fl. (V) yrkandena 1 och 2."
        
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let cleanedUpText = VotingUtil.createMotionItemsAndCleanup(text: decisionText, motionIds: motionIds).0
        
        let expected = "Utskottets förslag: Ändrade ramar för utgiftsområden och ändrade och nya anslag Riksdagen godkänner ändrade ramar för utgiftsområden och anvisar ändrade och nya anslag enligt utskottets förslag i bilaga 3. Därmed bifaller riksdagen delvis proposition [1] och avslår motionerna [2] och [3]. Utgiftsområde 9 Hälsovård, sjukvård och social omsorg Riksdagen a) bemyndigar regeringen att under 2020 som beredskapsinvestering ingå avtal om vaccin mot covid-19, b) bemyndigar regeringen att för 2020 besluta att Folkhälsomyndigheten får ta upp lån i Riksgäldskontoret för beredskapsinvesteringar som inklusive tidigare upplåning uppgår till högst 2 000 000 000 kronor. Därmed bifaller riksdagen proposition [1] punkterna 1 och 2 samt avslår motion [3] yrkande 2. Utgiftsområde 22 Kommunikationer Riksdagen godkänner den föreslagna användningen av anslaget 1:6 Ersättning avseende icke statliga flygplatser inom utgiftsområde 22 Kommunikationer. Därmed bifaller riksdagen proposition [1] punkt 3 och avslår motion [4]. Utgiftsområde 24 Näringsliv Riksdagen a) bemyndigar regeringen att under 2020 för anslaget 1:17 Kapitalinsatser i statliga ägda företag för statens räkning förvärva aktier eller andelar eller vidta andra liknande åtgärder som syftar till att rekapitalisera SAS AB med ett belopp om högst 5 000 000 000 kronor och inom denna ram öka statens röst- och ägarandel i bolaget, b) bemyndigar regeringen att vidta de övriga åtgärder som är nödvändiga för att möjliggöra statens deltagande i en rekapitalisering av SAS AB, c) bemyndigar regeringen att under 2020 för anslaget 1:17 Kapitalinsatser i statliga ägda företag inom utgiftsområde 24 Näringsliv besluta om kapitaltillskott på högst 3 150 000 000 kronor till Swedavia AB, d) bemyndigar regeringen att under 2020 för anslaget 1:17 Kapitalinsatser i statliga ägda företag inom utgiftsområde 24 Näringsliv besluta om kapitaltillskott på högst 150 000 000 kronor till Lernia AB, e) ställer sig bakom det som utskottet anför om Arlandas framtid och tillkännager detta för regeringen. Därmed bifaller riksdagen proposition [1] punkterna 4-7, bifaller delvis motionerna [5] och [3] yrkande 3 och avslår motionerna [5] yrkande 1 och [4] yrkandena 1 och 2."
        
        XCTAssert(cleanedUpText == expected, "Got \(cleanedUpText), expected \(expected)")
    }
    
    func testCreateMotionItems7() throws {
        let decisionText = "Vissa garanti- och medlemsavgifter inom utgiftsområde 2 Samhällsekonomi och finansförvaltning, f) godkänner ändrade ramar för utgiftsområden och anvisar ändrade och nya anslag enligt utskottets förslag i bilaga 3. Därmed bifaller riksdagen proposition 2019/20:181 punkterna 5-9, bifaller delvis proposition 2019/20:181 punkt 10 och avslår motionerna 2019/20:3629 av Jonas Sjöstedt m.fl. (V) yrkandena 2 och 3 samt 2019/20:3631 av Oscar Sjöstedt m.fl. (SD) yrkandena 4 och 5."
        
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let cleanedUpText = VotingUtil.createMotionItemsAndCleanup(text: decisionText, motionIds: motionIds).0
        
        let expected = "Vissa garanti- och medlemsavgifter inom utgiftsområde 2 Samhällsekonomi och finansförvaltning, f) godkänner ändrade ramar för utgiftsområden och anvisar ändrade och nya anslag enligt utskottets förslag i bilaga 3. Därmed bifaller riksdagen proposition [1], bifaller delvis proposition [1] punkt 10 och avslår motionerna [2] samt [3]."
        
        XCTAssert(cleanedUpText == expected, "Got \(cleanedUpText), expected \(expected)")
    }
    
    func testCreateMotionItems8() throws {
        let decisionText = "Riksdagen avslår motionerna 2019/20:220 av Christina Höj Larsen m.fl. (V) yrkandena 14 och 15, 2019/20:303 av Linda Lindberg (SD), 2019/20:475 av Magnus Manhammar (S), 2019/20:2461 av Mattias Karlsson i Luleå (M), 2019/20:2578 av Jonas Sjöstedt m.fl. (V) yrkande 19, 2019/20:2809 av Mikael Oscarsson (KD) yrkande 5, 2019/20:3191 av Andreas Carlson m.fl. (KD) yrkandena 24 i denna del, 25 och 27 i denna del och 2019/20:3316 av Teres Lindberg m.fl. (S) yrkande 2."
        
        let motionIds = VotingUtil.getMotionsIds(propositionText: decisionText)
        let cleanedUpText = VotingUtil.createMotionItemsAndCleanup(text: decisionText, motionIds: motionIds).0
        
        let expected = "Riksdagen avslår motionerna [1], [2], [3], [4], [5], [6], [7] och [8]."
        
        XCTAssert(cleanedUpText == expected, "Got \(cleanedUpText), expected \(expected)")
    }
    
    
    
    
    
    
    
}
