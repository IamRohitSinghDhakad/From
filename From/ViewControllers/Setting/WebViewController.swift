//
//  WebViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webVw: WKWebView!
    @IBOutlet weak var lblTitleHeader: UILabel!
    
    var isComingFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitleHeader.text = self.isComingFrom

        self.webVw.navigationDelegate = self
        self.webVw.uiDelegate = self
        
        var loadUrl = ""
        switch isComingFrom {
        case "Privacy Policy":
            loadUrl = "page/Privacy"
        case "Help center":
            loadUrl = "page/help"
        case "Terms and Conditions":
            loadUrl = "page/terms"
        case "About Us":
            loadUrl = "page/about"
        case "EULA":
            loadUrl = "page/EULA"
            
        default:
            break
        }
        
        
        // Do any additional setup after loading the view.
        if let url = URL(string: BASE_URL + loadUrl) {
            print(url)
            
            let request = URLRequest(url: url)
            self.webVw.load(request)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    
    @IBAction func BTNONBACK(_ sender: Any) {
        onBackPressed()
    }
    
}


extension WebViewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler{
    
    // WKNavigationDelegate methods
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Called when the web view finishes loading a page
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Called when the web view fails to load a page
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // Called when the web view begins to receive content
    }
    
    // WKUIDelegate methods
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Called when a link with target="_blank" is clicked
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        // Called when a web view that was created programmatically is closed
    }
    
    // WKScriptMessageHandler methods
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Called when a JavaScript message is received from the web view
    }
}
