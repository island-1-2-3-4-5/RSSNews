//
//  WebViewController.swift
//  RSSNews
//
//  Created by Roman on 10.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webOutlet: WKWebView!
    
   var selectedFeedURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: " ", with:"")
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: "\n", with:"")
        webOutlet.load(URLRequest(url: URL(string: selectedFeedURL! as String)!))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

    

}
