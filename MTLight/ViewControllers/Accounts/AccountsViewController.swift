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
    
    let dataSource = RxTableViewSectionedReloadDataSource<AccountSection>(
        configureCell: { (_, tableView, indexPath, account) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell")!
            cell.textLabel?.text = account.nickname
            cell.detailTextLabel?.text = account.formattedCurrentBalance
            return cell
        },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AccountsViewModel(
            accountSelected: tableView.rx.modelSelected(Account.self).asSignal(),
            service: MTService.shared,
            wireframe: AccountsWireframe(for: self)
        )

        setupUI()
        bindUI()
    }
    
    func setupUI() {
        self.title = L10n.balances
        
        headerTitleLabel.text = L10n.totalBalance
        
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
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func showErrorAlert(_ error: MTError) {
        let alert = UIAlertController(
            title: "Error",
            message: error.message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }


}

extension AccountsViewController: StoryboardInstantiatable {
    
    static var storyboard: UIStoryboard {
        return StoryboardScene.AccountsStoryboard.storyboard
    }
    
}
