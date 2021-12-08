//
//  HomeViewController.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/15.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

final class HomeViewController: AppViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "TestiOS"
        self.view.addSubview(self.stackView)
        self.stackView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(all: Style.padding.s))

        controllers.enumerated().forEach { (index, controller) in
            let button = self.getButtonForController(controller: controller, index: index)
            self.stackView.addArrangedSubview(button)
        }
    }

    private var controllers: [UIViewController] = [
        SkeletonViewController(),
        TableViewController(),
        ActivityController(),
        ChatAndMentionController(),
        ImageViewController(),
        DiffableDatasourceController(),
        CompositionController()
    ]

    private func getButtonForController(controller: UIViewController, index: Int) -> GenericButton {
        let title: String = controller.title ?? String(describing: type(of: controller))
        let button = GenericButton(title)
        button.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        button.tag = index
        button.backgroundColor = Style.colors.asbestos
        return button
    }

    @objc private func onButton(_ button: UIButton) {
        guard let controller = self.controllers.item(at: button.tag) else { return }

        self.route(to: controller)
    }

    // Subviews

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Style.padding.m
        stackView.distribution = UIStackView.Distribution.fillEqually
        return stackView
    }()
}
