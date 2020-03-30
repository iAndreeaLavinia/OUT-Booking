//
//  GlalleryDetailsViewController.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit
import WebKit

class LocationDetailsViewController: UIViewController {

    var locationInfo: LocationModel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self

        activityIndicator.startAnimating()
        
        let myURL = URL(string: locationInfo?.url ?? "")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension LocationDetailsViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading")
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
