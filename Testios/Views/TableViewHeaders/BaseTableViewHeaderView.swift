//
//  BaseTableViewHeaderView.swift
//  Testios
//
//  Created by Chad Garrett on 2021/11/15.
//  Copyright © 2021 Personal. All rights reserved.
//

import UIKit

public class BaseTableViewHeaderView: UIView {
    public static func configure(with text: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.attributedText = .init(string: text, attributes: Style.heading)

        view.addSubviewAndPinToSuperviewEdges(label, with: UIEdgeInsets.init(all: Style.padding.s))

        return view
    }
}
