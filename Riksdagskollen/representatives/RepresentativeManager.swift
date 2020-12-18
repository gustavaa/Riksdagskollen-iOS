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

let LAST_DOWNLOAD_KEY = "LAST_DOWNLOAD"
let downloadExpireTimeSeconds = 3600.0 * 24 * 2 * 24.0 * 2.0 // 2 days

class RepresentativeManager {
    
    static var shared = RepresentativeManager()
    
    var container = NSPersistentContainer(name: "Representative")
    var backgroundContext: NSManagedObjectContext!
    var decoder = JSONDecoder()
    var representatives = [String : [String : Representative]]()
    var currentRepresentatives = [Representative]()
    var downloadListeners = [RepresentativeDownloadedListener]()
    var representativesAreDownloaded = false
    
    public func initialize() {
        // load the database if it exists, if not create it.
        container.loadPersistentStores { storeDescription, error in
            // resolve conflict by using correct NSMergePolicy
            if let error = error {
                print("Unresolved error \(error)")
            }
            self.backgroundContext = self.container.newBackgroundContext()
            self.decoder.userInfo[CodingUserInfoKey.context!] = self.backgroundContext
            self.backgroundContext.mergePolicy = NSMergePolicy.overwrite
            
            let lastDownloadDate = UserDefaults.standard.object(forKey: LAST_DOWNLOAD_KEY) as! Date?
            // Check if data has expired
            if let downloadDate = lastDownloadDate, abs(Int32(downloadDate.timeIntervalSinceNow)) >= Int32(downloadExpireTimeSeconds){
                self.downloadCurrenRepresentativesInBackground()
            // Check if existing data exists and is non-empty, then use it
            } else if let result = try? self.backgroundContext.fetch(Representative.fetchRequest()), result.count > 0 {
                print("Found existing representative data, skipping re-download")
                self.addCurrentRepresentatives(representatives: result as! [Representative])
            // No previous data, re-download
            } else {
                self.downloadCurrenRepresentativesInBackground()
            }
        }
        
    }
    
    private func downloadCurrenRepresentativesInBackground(){
        print("No existing or old representative data, downloading...")
        UserDefaults.standard.setValue(Date(), forKey: LAST_DOWNLOAD_KEY)
        RepresentativeService.fetchAllCurrentRepresentatives(success: {_ in
            print("Representatives downloaded")
            try? self.backgroundContext.save()
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
    
    private func deleteAllRepresentativeData(){
        deleteAllDataForEntity(Representative.entity().name!)
        deleteAllDataForEntity(RepresentativeInfoList.entity().name!)
        deleteAllDataForEntity(RepresentativeInfo.entity().name!)
        deleteAllDataForEntity(RepresentativeMissionList.entity().name!)
        deleteAllDataForEntity(RepresentativeMission.entity().name!)
        try? backgroundContext.save()
    }
    
    private func deleteAllDataForEntity(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try backgroundContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                backgroundContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
        
    
    
}
