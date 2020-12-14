//
//  ProtocolReaderController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-14.
//

import UIKit
import WebKit

class ProtocolReaderController: UIViewController {

    @IBOutlet weak var webView: DocumentHtmlView!
    
    var protocolDocument: PartyDocument!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingOverlay.shared.showOverlay(in: view)
        webView.shouldResizeToContentSize = false
        webView.setDocument(document: protocolDocument, loadedCallback: {
            LoadingOverlay.shared.hideOverlayView()
        })
        // Do any additional setup after loading the view.
    }
}
