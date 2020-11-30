//
//  DecisionCategory.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-16.
//

import Foundation
import UIKit

struct DecisionCategory {

    let id: String
    let categoryName: String
    let categoryColor: UIColor
    init(id: String, categoryName: String, categoryColor: UIColor) {
        self.id = id
        self.categoryName = categoryName
        self.categoryColor = categoryColor
    }
}

struct DecisionCategories {
  
    static let FiU = DecisionCategory(id: "FiU", categoryName: "Finans", categoryColor: UIColor(named: "CatLightBlue")!)
    static let CU = DecisionCategory(id: "CU", categoryName: "Konsumentfrågor", categoryColor: UIColor(named: "CatTeal")!)
    static let AU = DecisionCategory(id: "AU", categoryName: "Arbetsmarknad", categoryColor: UIColor(named: "CatOrange")!)
    static let FöU = DecisionCategory(id: "FöU", categoryName: "Försvar och miltär", categoryColor: UIColor(named: "CatLime")!)
    static let JuU = DecisionCategory(id: "JuU", categoryName: "Kriminalitet och rättväsende", categoryColor: UIColor(named: "CatBlue")!)
    static let KU = DecisionCategory(id: "KU", categoryName: "Riksdagen", categoryColor: UIColor(named: "RiksdagBlue")!)
    static let KrU = DecisionCategory(id: "KrU", categoryName: "Kultur", categoryColor: UIColor(named: "CatPink")!)
    static let MjU = DecisionCategory(id: "MjU", categoryName: "Miljö och jordbruk", categoryColor: UIColor(named: "CatGreen")!)
    static let NU = DecisionCategory(id: "NU", categoryName: "Näringsliv", categoryColor: UIColor(named: "CatOrange")!)
    static let SkU = DecisionCategory(id: "SkU", categoryName: "Skatter", categoryColor: UIColor(named: "CatYellow")!)
    static let SfU = DecisionCategory(id: "SfU", categoryName: "Socialförsäkringar", categoryColor: UIColor(named: "CatBrown")!)
    static let SoU = DecisionCategory(id: "SoU", categoryName: "Vård och omsorg", categoryColor: UIColor(named: "CatRed")!)
    static let TU = DecisionCategory(id: "TU", categoryName: "Transport och kommunikation", categoryColor: UIColor(named: "CatDarkGray")!)
    static let UbU = DecisionCategory(id: "UbU", categoryName: "Utbildning", categoryColor: UIColor(named: "CatPurple")!)
    static let UU = DecisionCategory(id: "UU", categoryName: "Utrikesfrågor", categoryColor: UIColor(named: "CatLightGray")!)
    static let UFöU = DecisionCategory(id: "UFöU", categoryName: "Utrikesförsvar", categoryColor: UIColor(named: "CatLime")!)
    
    static let allCategories = [FiU, CU, AU, FöU, JuU, KU, KrU, MjU, NU, SkU, SfU, SoU, TU, UbU, UU, UFöU]
    
    static func getCategoryFromBet(bet: String) -> DecisionCategory? {
        let id = bet.trimmingCharacters(in: .decimalDigits)
        return allCategories.first(where: { $0.id == id })
    }
}

//private struct FiUCategory: DecisionCategory {
//    var id: String = "FiU"
//    var categoryName: String = "Finans"
//    var categoryColor: UIColor = UIColor.black
//}
//
//private struct CUCategory: DecisionCategory {
//    var id: String = "CU"
//    var categoryName: String = "Konsumentfrågor"
//    var categoryColor: UIColor = UIColor.black
//}
//
//private struct AUCategory: DecisionCategory {
//    var id: String = "AU"
//    var categoryName: String = "Arbetsmarknad"
//    var categoryColor: UIColor = UIColor.black
//}




