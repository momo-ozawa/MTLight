//
//  AccountsWireframe.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/08.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import UIKit

protocol AccountsWireframeProtocol {
    func routeToTransactions(with accoun: Account)
}

final class AccountsWireframe: AccountsWireframeProtocol {
    
    private weak var viewController: UIViewController?

    init(for viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToTransactions(with account: Account) {
        let dependency = TransactionsViewController.Dependency(account: account)
        let destinationVC = TransactionsViewController.instantiate(with: dependency)
        self.viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

}
