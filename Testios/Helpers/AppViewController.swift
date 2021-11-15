//
//  AppViewController.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/15.
//  Copyright © 2019 Personal. All rights reserved.
//

import PureLayout
import UIKit

class AppViewController: UIViewController {

    func setupView() {
        // Child classes to override
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.backgroundColor = UIColor.white
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Adds the passed view controller to the stack
    internal func route(to controller: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(controller, animated: animated)
        }
    }
}
