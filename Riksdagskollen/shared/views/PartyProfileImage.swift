//
//  PartyProfileImage.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-18.
//

import UIKit

class PartyProfileImage: UIView {
    
    var profileImageView: UIImageView
    private var partyLogoView: UIImageView
    var partyIndicatorSize: Int = 25
    
    required init?(coder: NSCoder) {
        self.profileImageView = UIImageView()
        self.partyLogoView = UIImageView()
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.layer.cornerRadius = frame.width/2
        self.clipsToBounds = false
        
        profileImageView.frame = bounds
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = frame.width/2
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        
        addSubview(profileImageView)
    }
    
    func setParty(partyId: String){
        partyLogoView.removeFromSuperview()
        let partyLogo = CurrentParties.getParty(id: partyId)?.logo
        partyLogoView.image = partyLogo 
        let size = CGFloat(partyIndicatorSize)
        partyLogoView.frame = CGRect(x: frame.width-size, y: frame.height-size, width: size, height: size)
        addSubview(partyLogoView)
    }

}
