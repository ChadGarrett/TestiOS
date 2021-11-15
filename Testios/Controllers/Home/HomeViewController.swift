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

        let buttons: [GenericButton] = [
            self.btnSkeletonView,
            self.btnTableView,
            self.btnActivityController,
            self.btnMentions,
            self.btnImages,
            self.btnDiffableDatasource
        ]

        buttons.forEach { [weak self] button in
            self?.stackView.addArrangedSubview(button)
        }
    }

    // Actions

    @objc private func onSkeletonView() {
        self.route(to: SkeletonViewController())
    }

    @objc private func onTableView() {
        self.route(to: TableViewController())
    }

    @objc private func onActivityController() {
        self.route(to: ActivityController())
    }

    @objc private func onMentions() {
        self.route(to: MentionViewController())
    }

    @objc private func onImages() {
        self.route(to: ImageViewController())
    }

    @objc private func onDiffableDatasource() {
        self.route(to: DiffableDatasourceController())
    }

    // Subviews

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Style.padding.m
        stackView.distribution = UIStackView.Distribution.fillEqually
        return stackView
    }()

    private lazy var btnSkeletonView: GenericButton = {
        let button = GenericButton("Skeleton view")
        button.addTarget(self, action: #selector(onSkeletonView), for: .touchUpInside)
        button.backgroundColor = Style.colors.lynchColor
        return button
    }()

    private lazy var btnTableView: GenericButton = {
        let button = GenericButton("Table selection")
        button.addTarget(self, action: #selector(onTableView), for: .touchUpInside)
        button.backgroundColor = Style.colors.nephritis
        return button
    }()

    private lazy var btnActivityController: GenericButton = {
        let button = GenericButton("Activity controller")
        button.addTarget(self, action: #selector(onActivityController), for: .touchUpInside)
        button.backgroundColor = Style.colors.wetAsphalt
        return button
    }()

    private lazy var btnMentions: GenericButton = {
        let button = GenericButton("Mentions")
        button.addTarget(self, action: #selector(onMentions), for: .touchUpInside)
        button.backgroundColor = Style.colors.belizeHole
        return button
    }()

    private lazy var btnImages: GenericButton = {
        let button = GenericButton("Images")
        button.addTarget(self, action: #selector(onImages), for: .touchUpInside)
        button.backgroundColor = Style.colors.monza
        return button
    }()

    private lazy var btnDiffableDatasource: GenericButton = {
        let button = GenericButton("Diffable datasource")
        button.addTarget(self, action: #selector(onDiffableDatasource), for: .touchUpInside)
        button.backgroundColor = Style.colors.peterRiver
        return button
    }()
}
