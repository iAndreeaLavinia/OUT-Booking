//
//  GlalleryDetailsViewController.swift
//  ArtGallery
//
//  Created by Andreea Lavinia Ionescu on 05/03/2020.
//  Copyright © 2020 Orange Labs Romania. All rights reserved.
//

import UIKit
import WebKit

class GlalleryDetailsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.uiDelegate = self
        
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GlalleryDetailsViewController: UIWebViewDelegate, WKUIDelegate {
    
    
}
