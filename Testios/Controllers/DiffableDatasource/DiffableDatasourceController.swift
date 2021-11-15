//
//  DiffableDatasourceController.swift
//  Testios
//
//  Created by Chad Garrett on 2020/04/14.
//  Copyright © 2020 Personal. All rights reserved.
//

import Fakery
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Generate and display initial data
        self.generateInitialData()
    }

    private func generateInitialData() {
        self.contactList = ContactList(
            friends: [
                self.getPerson(),
                self.getPerson(),
                self.getPerson()
            ],
            family: [
                self.getPerson(),
                self.getPerson(),
                self.getPerson()
            ])
    }

    /// Generates a random fake person
    private func getPerson() -> Contact {
        let faker = Faker()
        return .init(name: faker.name.firstName(), surname: faker.name.lastName())
    }

    // MARK: - Data

    private var contactList: ContactList = ContactList(friends: [], family: []) {
        didSet { self.contactListDidUpdate() }
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

    private func contactListDidUpdate() {
        self.update()
    }

    private func update(animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Contact>()
        snapshot.appendSections([.friends, .family])

        snapshot.appendItems(self.contactList.friends, toSection: .friends)
        snapshot.appendItems(self.contactList.family, toSection: .family)

        DispatchQueue.main.async { [dataSource] in
            dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }

    // MARK: Subviews

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tvc")
        return tableView
    }()

    private lazy var btnUpdate: GenericButton = {
        let button = GenericButton("Update")
        button.backgroundColor = Style.colors.asbestos
        button.addTarget(self, action: #selector(onUpdate), for: .touchUpInside)
        return button
    }()

    @objc private func onUpdate() {
        let listDecider = Int.random(in: 1...100)

        let person = self.getPerson()
        listDecider%2 == 0
            ? self.contactList.family.append(person)
            : self.contactList.friends.append(person)
    }
}

extension DiffableDatasourceController: UITableViewDelegate {

    // MARK: Table view header

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

    // MARK: Table view select

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section)
        else { return }

        switch section {
        case .friends: self.contactList.friends.remove(at: indexPath.row)
        case .family: self.contactList.family.remove(at: indexPath.row)
        }
    }
}
