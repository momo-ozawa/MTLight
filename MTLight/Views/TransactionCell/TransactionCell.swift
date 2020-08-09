//
//  TransactionCell.swift
//  MTLight
//
//  Created by Momo Ozawa on 2020/08/09.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell, NibLoadable {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with transaction: Transaction, currencyCode: String) {
        self.dateLabel.text = transaction.formattedDate
        self.descriptionLabel.text = transaction.description
        self.amountLabel.text = transaction.amount.toLocaleCurrency(currencyCode: currencyCode)
    }
    
}
