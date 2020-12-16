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
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var webView: DocumentHtmlView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var senderContainer: UIStackView!
    
    var partyDocument: PartyDocument!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isHidden = true
        LoadingOverlay.shared.showOverlay(in: view)
        webView.shouldResizeToContentSize = true
        
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
        verticalStackView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        let portraitView = PartyProfileImage(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        portraitView.translatesAutoresizingMaskIntoConstraints = false
        portraitView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        portraitView.clickable = true
        portraitView.showPartyIcon = false
        
        let nameLabel = TitleLabel()
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = nameLabel.font.withSize(14)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        RepresentativeService.fetchRepresentative(iid: iid, party: nil, success: { representative in
            guard let rep = representative else { return }
            portraitView.setRepresentative(representative: rep, imageSize: .medium)
            nameLabel.text = "\(rep.tilltalsnamn) \(rep.efternamn)"
            verticalStackView.addArrangedSubview(portraitView)
            verticalStackView.addArrangedSubview(nameLabel)
            self.senderContainer.addArrangedSubview(verticalStackView)
        }, failure: { error in
            print(error)
        })
    }
    

}
