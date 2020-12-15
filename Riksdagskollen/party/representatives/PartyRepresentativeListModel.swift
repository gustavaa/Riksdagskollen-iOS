//
//  PartyRepresentativeListModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-15.
//

import Foundation
import UIKit



class PartyRepresentativeListModel: RepresentativeDownloadedListener  {
    
    private let manager = RepresentativeManager.shared
    private let onDataChange: ()->()
    var representatives: [Representative] = []
    private var party: Party
    
    init(party: Party, onDataChange: @escaping ()->()) {
        self.onDataChange = onDataChange
        self.party = party
        if manager.representativesAreDownloaded {
            updateData()
        } else {
            manager.addDownloadListener(listener: self)
        }
    }
    
    
    func onRepresentativesDownloaded(_ representatives: [Representative]) {
       updateData()
    }
    
    func updateData(){
        self.representatives = manager.getCurrentRepresentativesForParty(party: party)
        self.representatives.sort(by: {$0.tilltalsnamn < $1.tilltalsnamn})
        self.onDataChange()
    }
    
    
    


}
