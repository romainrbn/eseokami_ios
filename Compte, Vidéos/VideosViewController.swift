//
//  VideosViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 18/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadRequest(URLRequest(url: URL(string: "https://www.youtube.com/embed/Y9GCM9DZUJo")!))
    }
    

    

}
