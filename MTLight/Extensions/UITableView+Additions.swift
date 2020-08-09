//
//  UITableView+Additions.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/09.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import UIKit

extension UITableView {

    // MARK: - Register UITableViewCell

    func register<T: UITableViewCell>(_: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    // MARK: - Dequeue UITableViewCell

    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Error: cell with id: \(T.reuseIdentifier) for indexPath: \(indexPath) is not \(T.self)"
            )
        }
        return cell
    }

}

extension UITableViewCell: Reusable {}
