//
//  PureLayout+App.swift
//  Testios
//
//  Created by Chad Garrett on 2021/11/15.
//  Copyright © 2021 Personal. All rights reserved.
//

import PureLayout

extension UIView {
    func addSubviewAndPinToSuperviewEdges(_ view: UIView, with insets: UIEdgeInsets = UIEdgeInsets()) {
        self.addSubview(view)
        view.autoPinEdgesToSuperviewEdges(with: insets)
    }
}
