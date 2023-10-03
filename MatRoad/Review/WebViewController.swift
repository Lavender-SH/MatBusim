//
//  WebViewController.swift
//  MatRoad
//
//  Created by 이승현 on 2023/10/03.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var urlToLoad: URL
    
    init(url: URL) {
        self.urlToLoad = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view.addSubview(webView)
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        webView.backgroundColor = .clear
        
        let request = URLRequest(url: urlToLoad)
        webView.load(request)
        print("==9==", urlToLoad)
        
//        // 네비게이션바 설정
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .black
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.tintColor = .white
//
//        // 백버튼 설정
//        let backButton = UIButton(type: .system)
//        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
//        backButton.addTarget(self, action: #selector(backToMainView), for: .touchUpInside)
//        backButton.tintColor = .white
//        let backBarButtonItem = UIBarButtonItem(customView: backButton)
//        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func backToMainView() {
        navigationController?.popViewController(animated: true)
    }
}
