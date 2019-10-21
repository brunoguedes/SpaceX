//
//  MissionDetailsViewController.swift
//  SpaceX
//
//  Created by Bruno Guedes on 21/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MissionDetailsViewController: UIViewController {
    
    private enum Constants {
        static let title = NSLocalizedString("Mission Details", comment: "MissionDetailsViewController Title")
        static let linkButtonTitle = NSLocalizedString("Tell me more about the rocket", comment: "link button title")
    }
    
    private let disposeBag = DisposeBag()
    private let spaceXService: SpaceXService
    private let spinnerView = UIActivityIndicatorView(style: .large)
    private let detailsObservable: Observable<(LaunchDetails, RocketDetails)>
    private let textView = UITextView()
    private let linkView = UIView()
    private let linkButton = UIButton()

    init(spaceXService: SpaceXService = SpaceXService(), flightNumber: Int) {
        self.spaceXService = spaceXService
        self.detailsObservable = spaceXService.getLaunchAndRocketDetails(for: flightNumber)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [textView, linkView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        view.backgroundColor = .systemBackground
        linkView.backgroundColor = .systemBackground
        
        linkButton.setTitle(Constants.linkButtonTitle, for: .normal)
        linkButton.setTitleColor(.link, for: .normal)
        linkButton.setTitleColor(.systemGray5, for: .disabled)
        linkButton.isEnabled = false
        linkView.addPinned(subView: linkButton, leading: .spacing3x, trailing: -.spacing3x, top: .spacing3x, bottom: -.spacing3x)
        
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            linkView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            textView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupBindings() {
        detailsObservable.subscribe(onNext: { [weak self] (details) in
            guard let this = self else { return }
            let missionDetails = MissionDetailsViewModel(launchDetails: details.0, rocketDetails: details.1)
            this.textView.text = missionDetails.details
            this.linkButton.isEnabled = true
            this.linkButton.rx.tap.bind {
                let webViewController = WebPageViewController(url: missionDetails.wikipediaURL)
                this.navigationController?.pushViewController(webViewController, animated: true)
            }.disposed(by: this.disposeBag)
        }).disposed(by: disposeBag)
        
        spaceXService.isLoading
            .bind(to: spinnerView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
}
