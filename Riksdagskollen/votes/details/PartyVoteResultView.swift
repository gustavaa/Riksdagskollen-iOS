//
//  VoteResultGraph.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-01.
//

import UIKit
import Charts
class PartyVoteResultView: UIStackView {
    
    private let logo: UIImageView
    private let chart = HorizontalBarChartView()
    private let resultDetailsLabel = UILabel()

    init(party: Party, partyResults: [Int]){
        logo = UIImageView(image: party.logo)
        super.init(frame: .zero)
        self.axis = .horizontal
        logo.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logo.contentMode = .scaleAspectFit
        addArrangedSubview(logo)
        addArrangedSubview(chart)
        setupChart(partyResults: partyResults)
    }
    
    required init(coder: NSCoder) {
        logo = UIImageView()
        super.init(coder: coder)
    }
    
    private func setupChart(partyResults: [Int]){
        let colors = [  UIColor(named:"YesVoteColor")!, UIColor(named: "NoVoteColor")!, ThemeManager.shared.theme!.refrainColor, ThemeManager.shared.theme!.absentColor]
        let labels = ["Ja", "Nej", "Avstående", "Frånvarande"]

        let filteredStackLabels = labels.enumerated().filter({(index, label) in return partyResults[index] > 0 }).map({(index, label) in return "\(label): \(partyResults[index])"})
        let filteredColors = colors.enumerated().filter({(index, color) in return partyResults[index] > 0 }).map({(index, color) in return color})
        
        let entry = BarChartDataEntry(x: 1, yValues: partyResults.filter({$0>0}).map({Double($0)}))
        let set1 = BarChartDataSet(entries: [entry], label: "")
        
        set1.stackLabels = filteredStackLabels
        set1.drawIconsEnabled = false
        set1.colors = filteredColors
        set1.drawValuesEnabled = false
        let chartData = BarChartData(dataSets: [set1])
        
        chart.data = chartData
        
        let xAxis = chart.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = false
        xAxis.drawAxisLineEnabled = false
                
        
        chart.leftAxis.drawLabelsEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        
        chart.rightAxis.drawLabelsEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawAxisLineEnabled = false
        
        chart.legend.enabled = true
        chart.legend.horizontalAlignment = .center
        chart.legend.font = chart.legend.font.withSize(14)
        chart.legend.textColor = ThemeManager.shared.theme!.mainBodyTextColor

        chart.drawValueAboveBarEnabled = false
        chart.isUserInteractionEnabled = false
        chart.fitBars = true
        chart.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
