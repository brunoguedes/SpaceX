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
    
    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    private let viewModel: LaunchesViewModel
    private let launches: Observable<Launches>
    private let filterOnlySuccessful = true
    private let sortedBy: LaunchesViewModel.SortBy = .date
    
    init(spaceXService: SpaceXService = SpaceXService()) {
        let launches = spaceXService.getLaunches()
        self.viewModel = LaunchesViewModel(
            launches: launches,
            onlySuccessful: Observable.from(optional: filterOnlySuccessful),
            sortedBy: Observable.from(optional: sortedBy)
        )
        self.launches = launches
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addPinned(subView: tableView)
        tableView.register(LaunchTableViewCell.self, forCellReuseIdentifier: LaunchTableViewCell.reuseIdentifier)
        bindRx()
    }
    
    func bindRx() {
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
    }

}
