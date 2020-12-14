//
//  DocumentHtmlView.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-04.
//

import Foundation
import UIKit
import WebKit
import SwiftSoup

class DocumentHtmlView: WKWebView, WKNavigationDelegate {
    
    var document: PartyDocument?
    var callback: (()->())?
    var shouldResizeToContentSize = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setDocument(document: PartyDocument, loadedCallback: @escaping (()->())){
        self.document = document
        self.navigationDelegate = self
        self.scrollView.bounces = false
        self.scrollView.zoomScale = 0.5

        self.scrollView.minimumZoomScale = 1
        
        self.callback = loadedCallback
        setupWebView()
    }
    
    private func setupWebView() {
        self.contentScaleFactor = 1
        
        guard let dokUrlString = document?.dokument_url_html, let url = URL(string: "https:\(dokUrlString)") else {return}
        _ = RiksdagenBaseService.makeStringRequest(url: url, success: {response in
            do {
                
                let doc = try SwiftSoup.parse(response)
                try doc.head()?.append("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1 text/html, charset='utf-8'\">\n")
                if let cssPath = Bundle.main.path(forResource: "motion_style", ofType: "css") {
                    try doc.head()?.appendElement("link").attr("rel", "stylesheet").attr("type", "text/css").attr("href", cssPath)
                }
                try doc.select("div>span.sidhuvud_publikation").remove();
                try doc.select("div>span.sidhuvud_beteckning").remove();
                try doc.select("div>span.MotionarLista").remove();
                try doc.select("div.pconf>h1").remove();
                try doc.select("div>hr.sidhuvud_linje").remove();
                try doc.select("head>style").remove();
                try doc.select("style").remove();
                try doc.select("body>div>br").remove();
                
                if self.document?.doktyp == "frs" {
                    try doc.select("body>div>div>p").get(0).addClass("DokumentRubrik");
                    try doc.select("body>div>div>table.webbtabell").remove();
                    try doc.body()?.replaceWith(doc.select("body>div>div").get(0));
                }
                let result = try doc.html().replacingOccurrences(of: "style=\"[A-Öa-ö-_:;\\s0-9.%']+\"", with: "", options: .regularExpression)
            
                self.loadHTMLString(result, baseURL: Bundle.main.bundleURL)
                self.setNeedsDisplay()                
            } catch {
                
            }
        }, failure: { error in
            print("Doc parsing in setup failed")
        })
        
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.shouldResizeToContentSize {
                self.heightAnchor.constraint(equalToConstant: webView.scrollView.contentSize.height).isActive = true
            }
            self.callback?()
        }
    }
}
