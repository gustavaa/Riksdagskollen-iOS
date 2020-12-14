//
//  PartyProfileImage.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-18.
//

import UIKit
import Kingfisher

class PartyProfileImage: UIView {
    
    enum ProfileImageSize {
        case small
        case medium
        case large
    }
    
    var clickable = false
    var profileImageView: UIImageView
    private var partyLogoView: UIImageView
    var partyIndicatorSize: Int = 25
    private var representative: Representative?
    
    override init(frame: CGRect){
        self.profileImageView = UIImageView()
        self.partyLogoView = UIImageView()
        super.init(frame: frame)
        initialize()
    }
    
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
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapListener = UITapGestureRecognizer(target: self, action: #selector(onViewClick(sender:)))
        self.addGestureRecognizer(tapListener)
        addSubview(profileImageView)
        
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

    }
    
    func setRepresentative(representative rep: Representative, imageSize: ProfileImageSize){
        var imageUrlString = ""
        switch(imageSize){
        case .small:
            imageUrlString = rep.bild_url_80
        case .medium:
            imageUrlString = rep.bild_url_192
        case .large:
            imageUrlString = rep.bild_url_max
        }
        self.representative = rep

        self.profileImageView.kf.setImage(with: URL(string: imageUrlString)!, completionHandler: { _ in
            self.setParty(partyId: rep.parti)
            self.sizeToFit()
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.isHidden = false
        })
    }
    
    func setRepresentative(iid: String, party: String?, imageSize: ProfileImageSize){
        RepresentativeService.fetchRepresentative(iid: iid, party: party, success: {representative in
            guard let rep = representative else { return }
            
            var imageUrlString = ""
            switch(imageSize){
            case .small:
                imageUrlString = rep.bild_url_80
            case .medium:
                imageUrlString = rep.bild_url_192
            case .large:
                imageUrlString = rep.bild_url_max
            }
            self.representative = rep

            self.profileImageView.kf.setImage(with: URL(string: imageUrlString)!, completionHandler: { _ in
                self.setParty(partyId: rep.parti)
                self.isHidden = false
            })
        }, failure: {_ in })
    }
    
    func setParty(partyId: String){
        partyLogoView.removeFromSuperview()
        let partyLogo = CurrentParties.getParty(id: partyId)?.logo
        partyLogoView.image = partyLogo 
        let size = CGFloat(partyIndicatorSize)
        partyLogoView.frame = CGRect(x: frame.width-size, y: frame.height-size, width: size, height: size)
        addSubview(partyLogoView)
    }
    
    @objc func onViewClick(sender: UITapGestureRecognizer) {
        if clickable, let rep = representative, let currentVC = self.parentViewController {
            let vc = RepresentativeDetailsController()
            vc.representative = rep
            currentVC.show(vc, sender: nil)
        }
    }
    
    

}
