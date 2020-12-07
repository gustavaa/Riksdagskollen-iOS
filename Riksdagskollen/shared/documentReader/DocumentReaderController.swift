//
//  DocumentReaderController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-04.
//

import UIKit
import WebKit
import Kingfisher

class DocumentReaderController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var authorLabel: TitleLabel!
    @IBOutlet weak var separator: SeparatorView!
    @IBOutlet weak var webView: DocumentHtmlView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var senderContainer: UIStackView!
    
    var partyDocument: PartyDocument!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !partyDocument.isMotion() {
            titleLabel.isHidden = true
            authorLabel.isHidden = true
            separator.isHidden = true
        } else {
            titleLabel.text = partyDocument.titel
            authorLabel.text = partyDocument.undertitel
        }
        webView.setDocument(document: partyDocument, loadedCallback: {
            LoadingOverlay.shared.hideOverlayView()
            self.scrollView.isHidden = false
        })
        webView.uiDelegate = self
        self.title = partyDocument.titel
        showSenders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LoadingOverlay.shared.showOverlay(in: view)
        scrollView.isHidden = true
    }
    
    private func showSenders(){
        for sender in partyDocument.getSenders(){
            showSender(iid: sender)
        }
    }
    
    private func showSender(iid: String){
        let verticalStackView = UIStackView()
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.alignment = .center
//        verticalStackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        verticalStackView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        let portraitView = PartyProfileImage(frame: CGRect(x: 0, y: 0, width: 70, height: 90))
        portraitView.translatesAutoresizingMaskIntoConstraints = false
        portraitView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        let nameLabel = TitleLabel()
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        RepresentativeService.fetchRepresentative(iid: iid, party: nil, success: { rep in
            portraitView.profileImageView.kf.setImage(with: URL(string: rep!.bild_url_192)!, completionHandler: { _ in
                portraitView.setParty(partyId: rep!.parti)
                nameLabel.text = "\(rep!.tilltalsnamn) \(rep!.efternamn)"
                verticalStackView.addArrangedSubview(portraitView)
                verticalStackView.addArrangedSubview(nameLabel)
                self.senderContainer.addArrangedSubview(verticalStackView)
                
            })
        }, failure: { error in
            print(error)
        })
    }
    

}
