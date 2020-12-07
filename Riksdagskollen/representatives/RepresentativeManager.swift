//
//  RepresentativeManager.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-18.
//

import Foundation

protocol RepresentativeDownloadedListener {
    func onRepresentativesDownloaded(_ representatives: [Representative]) -> ()
}

class RepresentativeManager {
    
    static var shared = RepresentativeManager()
    
    
    var representatives = [String : [String : Representative]]()
    var currentRepresentatives = [Representative]()
    var downloadListeners = [RepresentativeDownloadedListener]()
    var representativesAreDownloaded = false
    
    
    public func addRepresentative(rep: Representative){
        addRepresentativeToParty(party: rep.parti, rep: rep)
    }
    
    private func addRepresentativeToParty(party: String, rep: Representative){
        if representatives[party.lowercased()] == nil {
            representatives[party.lowercased()] = [String : Representative]()
        }
        representatives[party.lowercased()]![rep.intressent_id] = rep
    }
    
    public func addCurrentRepresentatives(representatives: [Representative]){
        currentRepresentatives.append(contentsOf: representatives)
        for rep in representatives {
            print("Added rep", rep.efternamn)
            addRepresentative(rep: rep)
        }
        representativesAreDownloaded = true
        notifyDownloaded()
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
    
    private func notifyDownloaded(){
        for listener in downloadListeners {
            listener.onRepresentativesDownloaded(currentRepresentatives)
        }
        clearDownloadListeners()
    }
    
    public func addDownloadListener(listener: RepresentativeDownloadedListener){
        downloadListeners.append(listener)
    }
    
    private func clearDownloadListeners(){
        downloadListeners.removeAll()
    }
        
    
    
}
