//
//  RepresentativeVoteStatistics.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-11.
//

import Foundation

class RepresentativeVoteStatistics: Codable {
    public var yes: String
    public var no: String
    public var absent: String
    public var abstained: String
    
    public var attendancePercentage: String? {
        guard let yesNumber = Double(yes) else { return nil }
        guard let noNumber = Double(no) else { return nil }
        guard let absentNumber = Double(absent) else { return nil }
        guard let abstainedNumber = Double(abstained) else { return nil }
        
        let percentage = Int(100*(yesNumber + noNumber + abstainedNumber)/(yesNumber + noNumber + absentNumber + abstainedNumber))
        return "\(percentage)%"
    }
    enum CodingKeys: String, CodingKey {
        case yes = "Ja"
        case no = "Nej"
        case absent = "Frånvarande"
        case abstained = "Avstår"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        yes = try container.decode(String.self, forKey: .yes)
        no = try container.decode(String.self, forKey: .no)
        absent = try container.decode(String.self, forKey: .absent)
        abstained = try container.decode(String.self, forKey: .abstained)
    }
    
}
