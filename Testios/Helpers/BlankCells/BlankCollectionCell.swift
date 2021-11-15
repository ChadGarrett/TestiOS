//
//  BlankCollectionCell.swift
//  Testios
//
//  Created by Chad Garrett on 2021/11/15.
//  Copyright © 2021 Personal. All rights reserved.
//

import Reusable
import UIKit

class BlankCollectionCell: UICollectionViewCell, Reusable {
    class var reuseIdentifier: String { return "BlankCollectionCell" }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoSetDimension(.height, toSize: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
