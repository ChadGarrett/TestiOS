//
//  TableViewController.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/23.
//  Copyright © 2019 Personal. All rights reserved.
//

import Reusable
import SwiftyBeaver
import UIKit

final class TableViewController: AppViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Table view"

        self.setupView()
    }

    override func setupView() {
        super.setupView()

        self.view.addSubview(self.tableView)
        self.tableView.autoPinEdgesToSuperviewSafeArea()
    }

    // Fake data

    private let tableData: [String] = [
        "Data 0",
        "Data 1",
        "Data 2",
        "Data 3",
        "Data 4",
        "Data 5",
        "Data 6",
        "Data 7",
        "Data 8",
        "Data 9"
    ]

    // Subviews

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsMultipleSelection = true
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: TableCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
}

extension TableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = self.tableData.item(at: indexPath.row)
            else { return self.getBlankCell(for: indexPath) }

        return self.getTableDataCell(for: indexPath, with: data)
    }

    private func getBlankCell(for indexPath: IndexPath) -> UITableViewCell {
        return self.tableView.dequeueReusableCell(for: indexPath, cellType: BlankTableCell.self)
    }

    private func getTableDataCell(for indexPath: IndexPath, with data: String) -> UITableViewCell {
        let cell: TableCell = self.tableView.dequeueReusableCell(for: indexPath)
        cell.prepareForDisplay(data: data)
        return cell
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCells = self.tableView.indexPathsForSelectedRows
            else { return }

        SwiftyBeaver.info("Selected \(selectedCells.count) cells")
        SwiftyBeaver.verbose("\(selectedCells)")
    }
}

extension TableViewController {
    final class TableCell: UITableViewCell, Reusable {

        private lazy var selectedBackground: UIView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width/2, height: self.frame.size.height))
//            view.backgroundColor = Style.colors.carrot
            view.alpha = 0.6
            view.layer.cornerRadius = 10
            return view
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            self.contentView.addSubview(self.lblHeading)
            self.lblHeading.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(all: Style.padding.xs))
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // Force animation
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: true)

            self.selectedBackgroundView?.backgroundColor = (selected) ? Style.colors.carrot : UIColor.white
        }

        internal func prepareForDisplay(data: String) {
            self.lblHeading.attributedText = NSAttributedString(string: data, attributes: Style.heading_1)
            self.selectedBackgroundView = self.selectedBackground
        }

        // Subviews

        private lazy var lblHeading: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
    }
}
