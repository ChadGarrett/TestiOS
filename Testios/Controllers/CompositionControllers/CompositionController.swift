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

    internal struct Item {
        var key: Int64
        var text: String
    }

    internal enum State {
        case loading
        case presenting(Item)
        case error
    }

    // MARK: - Properties

    private lazy var logicController = CompositionLogicController()

    // MARK: Properties

    private var state: State = .loading {
        didSet { self.stateDidUpdate() }
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
        self.logicController.load { state in
            loadingController.remove()
            self.state = state
        }
    }

    private func stateDidUpdate() {
        switch self.state {
        case .presenting(let item): self.render(item: item)
        case .error: self.handleError()
        case .loading: break
        }
    }

    private func render(item: Item) {
        self.onMain { [weak self] in
            self?.lblItemView.attributedText = .init(string: item.text, attributes: Style.callout)
        }
    }

    private func handleError() {

    }
}

class CompositionLogicController {
    typealias Handler = (CompositionController.State) -> Void

    private lazy var endpoint = MockEndpoint<CompositionController.Item>()

    func load(then handler: @escaping Handler) {
        self.endpoint.fetchData(.init(key: 1, text: "Item 1")) { result in
            if let item = try? result.get() {
                handler(.presenting(item))
            } else {
                handler(.error)
            }
        }
    }
}
