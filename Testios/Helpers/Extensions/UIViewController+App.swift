//
//  UIViewController+App.swift
//  Testios
//
//  Created by Chad Garrett on 2021/12/08.
//  Copyright © 2021 Personal. All rights reserved.
//

import UIKit

// MARK: Controller plugins

// https://www.swiftbysundell.com/articles/using-child-view-controllers-as-plugins-in-swift/
extension UIViewController {

    /// Adds the view controller to the current via composition
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        func _work() {
            // Just to be safe, we check that this view controller
            // is actually added to a parent before removing it.
            guard parent != nil else {
                return
            }

            willMove(toParent: nil)
            view.removeFromSuperview()
            removeFromParent()
        }

        DispatchQueue.main.async {
            _work()
        }
    }
}
