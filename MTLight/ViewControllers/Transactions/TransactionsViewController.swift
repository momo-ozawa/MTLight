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

    var viewModel: TransactionsViewModel!
    var dependency: Dependency!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = TransactionsViewModel(
            transactionId: dependency.accountId,
            service: MTService.shared
        )
        
        setupUI()
        bindUI()
    }

    
    func setupUI() {
        // self.title = L10n.balances
    }
    
    func bindUI() {
        
        viewModel.transactions
            .drive(
                tableView.rx.items(cellIdentifier: "TransactionCell", cellType: UITableViewCell.self)
            ) { (_, transaction, cell) in
                cell.textLabel?.text = transaction.description
                cell.detailTextLabel?.text = "\(transaction.amount)"
        }
        .disposed(by: disposeBag)
        
        viewModel.transactionsError
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

extension TransactionsViewController: StoryboardInstantiatable {
    
    static var storyboard: UIStoryboard {
        return StoryboardScene.TransactionsStoryboard.storyboard
    }
    
    struct Dependency {
        let accountId: Int
    }
    
    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

}
