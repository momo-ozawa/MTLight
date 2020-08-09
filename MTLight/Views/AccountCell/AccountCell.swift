//
//  AccountCell.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/09.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import UIKit

final class AccountCell: UITableViewCell, NibLoadable {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with account: Account) {
        self.textLabel?.text = account.nickname
        self.detailTextLabel?.text = account.formattedCurrentBalance
    }
    
}
