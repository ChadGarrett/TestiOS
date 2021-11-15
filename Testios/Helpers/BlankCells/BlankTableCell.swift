//
//  BlankTableCell.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/23.
//  Copyright © 2019 Personal. All rights reserved.
//

import Reusable

class BlankTableCell: UITableViewCell, Reusable {
    class var reuseIdentifier: String { return "BlankTableCell" }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.autoSetDimension(.height, toSize: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
