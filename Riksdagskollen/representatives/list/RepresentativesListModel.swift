//
//  RepresentativesListModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-08.
//

import Foundation
import UIKit

enum RepresentativesSortingOption {
    case firstName
    case lastName
    case age
    case district
}

enum RepresentativesSortOrderOption {
    case descending
    case ascending
}

class RepresentativesListModel: RepresentativeDownloadedListener  {
        

    
    let manager = RepresentativeManager.shared
    let onDataChange: ()->()
    var currentRepresentatives: [Representative] = []
    var currentSortingOption = RepresentativesSortingOption.firstName {
        didSet {
            updateData()
        }
    }
    var currentSortOrderOption = RepresentativesSortOrderOption.ascending {
        didSet {
            updateData()
        }
    }

    
    init(onDataChange: @escaping ()->()) {
        self.onDataChange = onDataChange
        if manager.representativesAreDownloaded {
            self.currentRepresentatives = manager.currentRepresentatives
        } else {
            manager.addDownloadListener(listener: self)
        }
    }
    
    func onRepresentativesDownloaded(_ representatives: [Representative]) {
        self.currentRepresentatives = representatives
        self.updateData()
    }
    
    private func updateData(){
        switch currentSortingOption {
            case .firstName:
                if currentSortOrderOption == .ascending {
                    self.currentRepresentatives.sort(by: {$0.tilltalsnamn < $1.tilltalsnamn})
                } else {
                    self.currentRepresentatives.sort(by: {$1.tilltalsnamn < $0.tilltalsnamn})
                }
            case .lastName:
                if currentSortOrderOption == .ascending {
                    self.currentRepresentatives.sort(by: {$0.efternamn < $1.efternamn})
                } else {
                    self.currentRepresentatives.sort(by: {$1.efternamn < $0.efternamn})
                }
            case .age:
                if currentSortOrderOption == .ascending {
                    self.currentRepresentatives.sort(by: {$1.fodd_ar < $0.fodd_ar})
                } else {
                    self.currentRepresentatives.sort(by: {$0.fodd_ar < $1.fodd_ar})
                }
            case .district:
                if currentSortOrderOption == .ascending {
                    self.currentRepresentatives.sort(by: {$0.valkrets < $1.valkrets})
                } else {
                    self.currentRepresentatives.sort(by: {$1.valkrets < $0.valkrets})
                }
        }
        onDataChange()
    }
    
    
    


}
