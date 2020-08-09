//
//  TransactionsViewController.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/08.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class TransactionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private let disposeBag = DisposeBag()
    private var viewModel: TransactionsViewModel!
    private var dependency: Dependency!
    
    private lazy var sectionDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = L10n.mmmmYyyy
        return dateFormatter
    }()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<TransactionSection>(
        configureCell: { (_, tableView, indexPath, transaction) in
            let cell = tableView.dequeueReusableCell(TransactionCell.self, for: indexPath)
            cell.configure(with: transaction, currencyCode: self.dependency.account.currency)
            return cell
        },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return self.sectionDateFormatter.string(from: dataSource[sectionIndex].model)
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = TransactionsViewModel(
            accountId: dependency.account.id,
            service: MTService.shared,
            wireframe: TransactionsWireframe(for: self)
        )
        
        setupUI()
        bindUI()
    }

    
    func setupUI() {
        // Set the title for the accounts screen
        self.title = dependency.account.institution
        
        // Register the transaction cell so we can dequeue it later
        tableView.register(TransactionCell.self)
    }
    
    func bindUI() {
        
        viewModel.transactions
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.transactionsError
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error)
            })
            .disposed(by: disposeBag)
        
    }

}

extension TransactionsViewController: StoryboardInstantiatable {
    
    static var storyboard: UIStoryboard {
        return StoryboardScene.TransactionsStoryboard.storyboard
    }
    
    struct Dependency {
        let account: Account
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

}

extension TransactionsViewController: AlertDisplayable {}
