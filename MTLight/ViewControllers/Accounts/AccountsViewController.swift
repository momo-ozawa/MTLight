//
//  AccountsViewController.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/07.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class AccountsViewController: UIViewController {
    
    private enum Constants {
        static let HeaderHeightMultiplier: CGFloat = 1 / 5
    }

    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var viewModel: AccountsViewModel!
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<AccountSection>(
        configureCell: { (_, tableView, indexPath, account) in
            let cell = tableView.dequeueReusableCell(AccountCell.self, for: indexPath)
            cell.configure(with: account)

            return cell
        },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AccountsViewModel(
            accountSelectedTap: tableView.rx.modelSelected(Account.self).asSignal(),
            service: MTService.shared,
            wireframe: AccountsWireframe(for: self)
        )

        setupUI()
        bindUI()
    }
    
    func setupUI() {
        // Set the title for the balances screen
        self.title = L10n.balances
        
        // Register the account cell so we can dequeue it later
        tableView.register(AccountCell.self)
        
        // Configure default values for the table header view
        headerTitleLabel.text = L10n.totalBalance
        totalBalanceLabel.text = 0.0.toLocaleCurrency(currencyCode: L10n.jpy)
        
        // Adjust table header view height
        guard let headerView = tableView.tableHeaderView else { return }
        headerView.frame.size.height = tableView.frame.size.height * Constants.HeaderHeightMultiplier
        tableView.layoutIfNeeded()

    }
    
    func bindUI() {
        
        viewModel.accounts
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.totalBalance
            .drive(totalBalanceLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.accountsError
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error)
            })
            .disposed(by: disposeBag)
    }

}

extension AccountsViewController: StoryboardInstantiatable {
    
    static var storyboard: UIStoryboard {
        return StoryboardScene.AccountsStoryboard.storyboard
    }
    
}

extension AccountsViewController: AlertDisplayable {}
