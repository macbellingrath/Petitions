//
//  DetailViewController.swift
//  Petitions
//
//  Created by Mac Bellingrath on 7/28/15.
//  Copyright © 2015 Mac Bellingrath. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: [String:String]!

    
    override func loadView() {
        webView = WKWebView()
        view = webView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
               
        
        
        if let body = detailItem["body"] {
            var html = "<html>"
                html += "<head>"
                    html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
                    html += "<style> body {font-size: 120%; color:ffffff; background-color:333333;} </style>"
                html += "</head>"
                    html += "<body>"
                        html += body
                    html += "</body>"
            html += "</html>"
            webView.loadHTMLString(html, baseURL: nil)
            title = "Signatures Needed: " + detailItem["signaturesNeeded"]!
        }
        
    }

 
}

