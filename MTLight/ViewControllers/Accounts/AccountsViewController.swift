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

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var viewModel: AccountsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AccountsViewModel(service: MTService.shared)
        
        setupUI()
        bindUI()
    }
    
    func setupUI() {
        self.title = L10n.balances
    }
    
    func bindUI() {
        
        viewModel.accounts
            .drive(
                tableView.rx.items(cellIdentifier: "AccountCell", cellType: UITableViewCell.self)
            ) { (_, account, cell) in
                cell.textLabel?.text = account.nickname
                cell.detailTextLabel?.text = "\(account.currency)\(account.currentBalance)"
            }
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
