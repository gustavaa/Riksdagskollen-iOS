//
//  RepresentativeManager.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-18.
//

import Foundation
import CoreData
protocol RepresentativeDownloadedListener {
    func onRepresentativesDownloaded(_ representatives: [Representative]) -> ()
}


class RepresentativeManager {
    
    static var shared = RepresentativeManager()
    
    var representatives = [String : [String : Representative]]()
    var currentRepresentatives = [Representative]()
    var downloadListeners = [RepresentativeDownloadedListener]()
    var representativesAreDownloaded = false
    
    public func initialize() {
        self.downloadCurrenRepresentativesInBackground()
    }
    
    private func downloadCurrenRepresentativesInBackground(){
        RepresentativeService.fetchAllCurrentRepresentatives(success: {representatives in
            print("Representatives downloaded")
            self.addCurrentRepresentatives(representatives: representatives!)
        }, failure: {_ in
            
        })
    }
    
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
        currentRepresentatives.removeAll()
        currentRepresentatives.append(contentsOf: representatives)
        for rep in representatives {
            addRepresentative(rep: rep)
        }
        representativesAreDownloaded = true
        notifyDownloaded()
    }
    
    public func getCurrentRepresentativesForParty(party: Party) -> [Representative]{
        return currentRepresentatives.filter({ return $0.parti.lowercased() == party.id.lowercased()})
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
            print("Notifying")
            listener.onRepresentativesDownloaded(currentRepresentatives)
        }
//        clearDownloadListeners()
    }
    
    public func addDownloadListener(listener: RepresentativeDownloadedListener){
        downloadListeners.append(listener)
    }
    
    private func clearDownloadListeners(){
        downloadListeners.removeAll()
    }
        
    
    
}
