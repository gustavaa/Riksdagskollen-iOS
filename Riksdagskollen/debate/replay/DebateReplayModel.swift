//
//  DebateReplayModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-23.
//

import Foundation

class DebateReplayModel {
    
    var initiatingDocument: PartyDocument?
    var protocolId: String?
    var debateInitiator: String?
    
    init(initiatingDocument: PartyDocument?) {
        self.initiatingDocument = initiatingDocument
        if initiatingDocument?.getSenders().count ?? 0 > 0 {
            debateInitiator = initiatingDocument?.getSenders()[0]
        }
    }
    
    public func getProtocolForDate(_ onProtocolFetched: @escaping((_ protocols: [PartyDocument])->()), onError: @escaping((String)->())){
        DebateService.getProtocolForDate(date: initiatingDocument!.debattdag, rm: initiatingDocument!.rm, success: onProtocolFetched) { error in
            onError(error)
        }
    }
    
    public func getSpeech(speechNo: String,_ onSpeechFetched:  @escaping((_ speech: Speech?)->()), onError: @escaping((String)->())) {
        DebateService.getSpeech(protId: protocolId!, speechNo: speechNo, success: onSpeechFetched) { error in
            onError(error)
        }
    }
    

}
