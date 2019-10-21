//
//  LaunchesViewController.swift
//  SpaceX
//
//  Created by Bruno Guedes on 20/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class LaunchesViewController: UIViewController {
    
    private enum Constants {
        static let title = NSLocalizedString("SpaceX Launches", comment: "LaunchesViewController Title")
        static let sortByDateText = NSLocalizedString("Sort by Date", comment: "Sort by date segment control text")
        static let sortByMissionNameText = NSLocalizedString("Sort by Mission Name", comment: "Sort by date segment control text")
        static let noFilterText = NSLocalizedString("All Launches", comment: "No filter segment control text")
        static let filterSuccessfulText = NSLocalizedString("Only Successful", comment: "Filter successful segment control text")
    }
    
    private let disposeBag = DisposeBag()
    private let spaceXService: SpaceXService
    private let controlsView = UIView()
    private let sortingSegmentedControl = UISegmentedControl(items: [Constants.sortByDateText, Constants.sortByMissionNameText])
    private let filteringingSegmentedControl = UISegmentedControl(items: [Constants.noFilterText, Constants.filterSuccessfulText])
    private let tableView = UITableView()
    private let spinnerView = UIActivityIndicatorView(style: .large)
    private let viewModel: LaunchesViewModel
    private let launches: Observable<Launches>
    private let filterOnlySuccessful = false
    private let sortedBy: LaunchesViewModel.SortBy = .date
    
    init(spaceXService: SpaceXService = SpaceXService()) {
        self.spaceXService = spaceXService
        let launches = spaceXService.getLaunches()
        self.viewModel = LaunchesViewModel(
            launches: launches,
            onlySuccessful: filteringingSegmentedControl.rx.selectedSegmentIndex.asObservable().map { return $0 == 0 ? false : true },
            sortedBy: sortingSegmentedControl.rx.selectedSegmentIndex.asObservable().map { return $0 == 0 ? .date : .missionName }
        )
        self.launches = launches
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.title
        tableView.register(LaunchTableViewCell.self, forCellReuseIdentifier: LaunchTableViewCell.reuseIdentifier)
        
        setupUI()
        setupBindings()
    }
    
    func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [controlsView, tableView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        controlsView.backgroundColor = .systemBackground
        
        sortingSegmentedControl.selectedSegmentIndex = 0
        filteringingSegmentedControl.selectedSegmentIndex = 0
        
        let controlsStackView = UIStackView(arrangedSubviews: [sortingSegmentedControl, filteringingSegmentedControl])
        controlsStackView.axis = .vertical
        controlsStackView.distribution = .equalSpacing
        controlsStackView.alignment = .center
        controlsStackView.spacing = .spacing2x
        controlsStackView.isLayoutMarginsRelativeArrangement = true
        controlsStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: .spacing3x, leading: .spacing3x, bottom: .spacing3x, trailing: .spacing3x)
        controlsStackView.backgroundColor = .systemBackground
        controlsView.addPinned(subView: controlsStackView)
        
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controlsView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            tableView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupBindings() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfLaunches>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.reuseIdentifier, for: indexPath) as? LaunchTableViewCell else {
                    fatalError()
                }
                cell.configure(launchViewModel: item)
                return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        viewModel.launchesBasicInfoBySection
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        spaceXService.isLoading
            .bind(to: spinnerView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
}
