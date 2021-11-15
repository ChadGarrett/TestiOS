//
//  UIEdgeInsets+App.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/15.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    /// Inset all sides with the same amount
    init(all inset: CGFloat) {
        self.init(
            top: inset,
            left: inset,
            bottom: inset,
            right: inset)
    }

    init(insetHorizontal: CGFloat, insetVertical: CGFloat) {
        self.init(
            top: insetVertical,
            left: insetHorizontal,
            bottom: insetVertical,
            right: insetHorizontal)
    }
}
