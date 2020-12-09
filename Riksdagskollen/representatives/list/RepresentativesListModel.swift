//
//  RepresentativesListModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-08.
//

import Foundation
import UIKit

enum RepresentativesSortingOption: Int {
    case firstName = 0
    case lastName = 1
    case age = 2
    case district = 3
}

enum RepresentativesSortOrderOption: Int {
    case ascending = 0
    case descending = 1
}

let REP_SORT_ORDER_KEY = "REP_SORT_ORDER"
let REP_SORT_FEATURE_KEY = "REP_SORT_FEATURE"
let REP_FILTERED_PARTIES_KEY = "REP_FILTERED_PARTIES"

class RepresentativesListModel: RepresentativeDownloadedListener  {
    
    private let manager = RepresentativeManager.shared
    private let onDataChange: ()->()
    var currentRepresentatives: [Representative] = []
    var currentSortingOption = RepresentativesSortingOption(rawValue: UserDefaults.standard.integer(forKey: REP_SORT_FEATURE_KEY) ){
        didSet {
            UserDefaults.standard.setValue(currentSortingOption?.rawValue, forKey: REP_SORT_FEATURE_KEY)
            updateData()
        }
    }
    var currentSortOrderOption = RepresentativesSortOrderOption(rawValue: UserDefaults.standard.integer(forKey: REP_SORT_ORDER_KEY) ) {
        didSet {
            UserDefaults.standard.setValue(currentSortOrderOption?.rawValue, forKey: REP_SORT_ORDER_KEY)
            updateData()
        }
    }
    var filteredParties: Set = Set(UserDefaults.standard.stringArray(forKey: REP_FILTERED_PARTIES_KEY) ?? CurrentParties.values.map({$0.id})) {
        didSet {
            UserDefaults.standard.setValue([String](filteredParties), forKey: REP_FILTERED_PARTIES_KEY)
            updateData()
        }
    }
    
    var isAllPartiesSelected: Bool {
        filteredParties.count == CurrentParties.values.count
    }

    func updateFilter(filteredParties: Set<String>){
        self.filteredParties = filteredParties
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
        self.updateData()
    }
    
    private func updateData(){
        currentRepresentatives = manager.currentRepresentatives.filter({filteredParties.contains($0.parti.lowercased())})
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
        default:
            if currentSortOrderOption == .ascending {
                self.currentRepresentatives.sort(by: {$0.tilltalsnamn < $1.tilltalsnamn})
            } else {
                self.currentRepresentatives.sort(by: {$1.tilltalsnamn < $0.tilltalsnamn})
            }
        }
        onDataChange()
    }
    
    
    


}
