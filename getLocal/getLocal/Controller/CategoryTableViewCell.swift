//
//  CategoryTableViewCell.swift
//  getLocal
//
//  Created by Kirilov, Hristo on 21.02.18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
