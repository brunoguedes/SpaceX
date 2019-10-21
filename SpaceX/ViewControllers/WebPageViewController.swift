//
//  WebPageViewController.swift
//  SpaceX
//
//  Created by Bruno Guedes on 22/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class WebPageViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let spinnerView = UIActivityIndicatorView(style: .large)
    private let webView = WKWebView()
    private let url: URL

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func setupUI() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        view.backgroundColor = .systemBackground
        
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupBindings() {
        
        webView.rx.isLoading
            .bind(to: spinnerView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
}

extension Reactive where Base: WKWebView {

    var isLoading: Observable<Bool> {
        return observeWeakly(Bool.self, "loading", options: [.initial, .new]).map { $0 ?? false }
    }

}
