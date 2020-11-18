//
//  RepresentativeManager.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-18.
//

import Foundation

class RepresentativeManager {
    
    static var shared: RepresentativeManager = {
        let representativeManager = RepresentativeManager()
        return representativeManager
    }()
    
    var representatives = [String : [String : Representative]]();
    
    public func addRepresentative(rep: Representative){
        addRepresentativeToParty(party: rep.parti, rep: rep)
    }
    
    private func addRepresentativeToParty(party: String, rep: Representative){
        if representatives[party.lowercased()] == nil {
            representatives[party.lowercased()] = [String : Representative]()
        }
        representatives[party.lowercased()]![rep.intressent_id] = rep
    }
    
    public func getRepresentative(iid: String, party: String?) -> Representative?{
        if party != nil {
            return representatives[party!.lowercased()]?[iid]
        }
        
        for party in representatives.keys {
            let partyReps = representatives[party.lowercased()]!
            if let rep = partyReps[iid] {
                return rep
            }
        }
        return nil
    }
        
   
    
    
    
    
}
