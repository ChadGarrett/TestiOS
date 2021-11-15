//
//  DiffableDatasourceController.swift
//  Testios
//
//  Created by Chad Garrett on 2020/04/14.
//  Copyright © 2020 Personal. All rights reserved.
//

import Reusable
import UIKit

final class DiffableDatasourceController: AppViewController {

    private lazy var dataSource = self.makeDataSource()

    // MARK: Setup

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self

        self.view.addSubview(self.btnUpdate)
        self.btnUpdate.autoPinEdge(toSuperviewSafeArea: .bottom)
        self.btnUpdate.autoPinEdge(toSuperviewEdge: .left, withInset: Style.padding.s)
        self.btnUpdate.autoPinEdge(toSuperviewEdge: .right, withInset: Style.padding.s)

        self.view.addSubview(self.tableView)
        self.tableView.autoPinEdge(toSuperviewEdge: .top)
        self.tableView.autoPinEdge(toSuperviewEdge: .left)
        self.tableView.autoPinEdge(toSuperviewEdge: .right)
        self.tableView.autoPinEdge(.bottom, to: .top, of: self.btnUpdate)

        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            var list: ContactList = ContactList(friends: [], family: [])

            list.friends.append(contentsOf: [
                .init(name: "chad", surname: "garrett"),
                .init(name: "ime", surname: "du plessis")
            ])

            list.family.append(contentsOf: [
                .init(name: "page", surname: "garrett"),
                .init(name: "clive", surname: "garrett")
            ])

            self.update(with: list)
        }
    }

    enum Section: Int, CaseIterable {
        case friends = 0
        case family
    }

    struct Contact: Hashable {
        let name: String
        let surname: String
    }

    struct ContactList: Hashable {
        var friends: [Contact]
        var family: [Contact]
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Contact> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, contact in
                let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tvc", for: indexPath)
                cell.textLabel?.attributedText = .init(string: contact.name, attributes: Style.body)
                return cell
            }
        )
    }

    private func update(with list: ContactList, animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Contact>()
        snapshot.appendSections(Section.allCases)

        snapshot.appendItems(list.friends, toSection: .friends)
        snapshot.appendItems(list.family, toSection: .family)

        self.dataSource.apply(snapshot, animatingDifferences: animate)
    }

    func remove(_ contact: Contact, animate: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([contact])
        self.dataSource.apply(snapshot, animatingDifferences: animate)
    }

    // MARK: Subviews

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tvc")
        return tableView
    }()

    private lazy var btnUpdate: GenericButton = {
        let button = GenericButton("Update")
        button.addTarget(self, action: #selector(onUpdate), for: .touchUpInside)
        return button
    }()

    @objc private func onUpdate() {
        var list: ContactList = ContactList(friends: [], family: [])

        list.friends.append(contentsOf: [
            .init(name: "chad", surname: "garrett"),
            .init(name: "ime", surname: "du plessis")
        ])

        list.family.append(contentsOf: [
            .init(name: "page", surname: "garrett"),
            .init(name: "clive", surname: "garrett")
        ])

        self.update(with: list)
    }

}

extension DiffableDatasourceController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section)
        else { return nil }

        return self.getHeaderView(for: section)
    }

    private func getHeaderView(for section: Section) -> UIView {
        switch section {
        case .friends: return BaseTableViewHeaderView.configure(with: "Friends")
        case .family: return BaseTableViewHeaderView.configure(with: "Family")
        }
    }
}
