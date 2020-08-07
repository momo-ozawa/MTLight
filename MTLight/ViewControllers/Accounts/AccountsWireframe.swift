//
//  AccountsWireframe.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/08.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import UIKit

protocol AccountsWireframeProtocol {
    func routeToTransactions(with accountId: Int)
}

final class AccountsWireframe: AccountsWireframeProtocol {
    
    private weak var viewController: UIViewController?

    init(for viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToTransactions(with accountId: Int) {
        let dependency = TransactionsViewController.Dependency(accountId: accountId)
        let destinationVC = TransactionsViewController.instantiate(with: dependency)
        self.viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

}
