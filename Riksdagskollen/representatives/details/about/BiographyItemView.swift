//
//  BiographyItemView.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-14.
//

import Foundation
import UIKit

class BiographyItemView: UIView {
    
    var titleLabel = TitleLabel()
    var infoLabel = BodyLabel()
    
    init() {
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func initialize() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabel.font.withSize(16)
        titleLabel.font = titleLabel.font.bold()
        titleLabel.numberOfLines = 0
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = infoLabel.font.withSize(15)
        infoLabel.numberOfLines = 0
        
        addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    func setup(withTitel titel: String, withBody body: String){
        titleLabel.text = titel
        infoLabel.text = body
    }
}
