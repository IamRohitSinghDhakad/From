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
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BTNONBACK(_ sender: Any) {
        onBackPressed()
    }
    
}
