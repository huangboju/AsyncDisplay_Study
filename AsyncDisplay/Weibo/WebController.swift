//
//  WebController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import WebKit

class WebController: UIViewController {

    let url: URL

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.frame)
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.showTitleView(text: "Loading")
        
        view.addSubview(webView)
        
        let request = URLRequest(url: url)

        webView.load(request)

        webView.navigationDelegate = self
    }
}

extension WebController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        navigationItem.hideTitleView()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationItem.hideTitleView()
    }
}
