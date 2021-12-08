//
//  LoadingController.swift
//  Testios
//
//  Created by Chad Garrett on 2021/12/08.
//  Copyright © 2021 Personal. All rights reserved.
//

import UIKit

final class LoadingController: UIViewController {

    // MARK: Setup

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingIndication.color = Style.colors.dodgerBlue
        self.loadingIndication.style = .large

        loadingIndication.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndication)

        NSLayoutConstraint.activate([
            loadingIndication.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndication.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Slight delay to it starting in case data is cached or loaded very quickly
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self?.view.backgroundColor = Style.colors.carrot.withAlphaComponent(0.6)
                }
                self?.loadingIndication.startAnimating()
            }
        }
    }

    // MARK: - Subviews

    private lazy var loadingIndication = UIActivityIndicatorView()
}
