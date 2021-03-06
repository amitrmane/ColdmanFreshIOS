//
//  WebVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2020 Prasad Patil. All rights reserved.
//

import UIKit
import WebKit

class WebVC: SuperViewController {

    @IBOutlet weak var webV : WKWebView!
    @IBOutlet weak var labelTitle : UILabel!

    var webUrl : URL!
    var pageTitle = ""
    var isFromSignUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.labelTitle.text = pageTitle
        self.webV.navigationDelegate = self
        self.webV.uiDelegate = self
        self.webV.load(URLRequest(url: webUrl!))
        
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        if isFromSignUp {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension WebVC : WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        self.hideActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        self.hideActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideActivityIndicator()
    }
}
