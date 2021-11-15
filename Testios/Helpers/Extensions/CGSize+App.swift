//
//  CGSize+App.swift
//  Testios
//
//  Created by Chad Garrett on 2021/11/15.
//  Copyright © 2021 Personal. All rights reserved.
//

import UIKit

extension CGSize {
    static func square(of size: CGFloat) -> CGSize {
        return CGSize(width: size, height: size)
    }
}
