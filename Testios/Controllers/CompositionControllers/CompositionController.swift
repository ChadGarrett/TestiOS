//
//  CompositionController.swift
//  Testios
//
//  Created by Chad Garrett on 2021/12/08.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation
import UIKit

/// Lightweight controller that has most functionallity added via view controller composition
final class CompositionController: AppViewController {

    private struct Item {
        var key: Int64
        var text: String
    }

    // MARK: - Properties

    private lazy var endpoint = MockEndpoint<Item>()

    // MARK: Properties

    private var item: Item? {
        didSet { self.itemDidUpdate() }
    }

    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.btnLoadData)
        self.btnLoadData.autoCenterInSuperviewMargins()

        self.view.addSubview(self.lblItemView)

        self.lblItemView.autoPinEdge(.top, to: .bottom, of: self.btnLoadData)
    }

    // MARK: - Subviews
    // TODO: This could be separate too

    private lazy var btnLoadData: AppButton = {
        let button = AppButton("Fetch data")
        button.addTarget(self, action: #selector(onFetchData), for: .touchUpInside)
        button.backgroundColor = Style.colors.capeHoney
        return button
    }()

    private lazy var lblItemView = UILabel()

    // MARK: - Action

    @objc private func onFetchData() {

        let loadingController = LoadingController()
        self.add(loadingController)

        self.endpoint.fetchData(.init(key: 1, text: "Item 1")) { result in
            loadingController.remove()
            if let item = try? result.get() {
                self.item = item
            }
        }
    }

    private func itemDidUpdate() {
        guard let item = item
        else { return }

        self.onMain { [weak self] in
            self?.lblItemView.attributedText = .init(string: item.text, attributes: Style.callout)
        }
    }
}
