//
//  UIAlertController+App.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/23.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addCancelAction(title: String? = nil) {
        let cancelAction = UIAlertAction(
            title: title ?? "Cancel",
            style: .cancel,
            handler: nil)
        self.addAction(cancelAction)
    }
}
