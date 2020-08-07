//
//  TransactionsWireframe.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/08.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import UIKit

protocol TransactionsWireframeProtocol {}

final class TransactionsWireframe: TransactionsWireframeProtocol {
    
    private weak var viewController: UIViewController?

    init(for viewController: UIViewController) {
        self.viewController = viewController
    }

}
