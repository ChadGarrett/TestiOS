//
//  MessageCell.swift
//  Testios
//
//  Created by Chad Garrett on 2021/11/15.
//  Copyright © 2021 Personal. All rights reserved.
//

import Reusable

extension ChatAndMentionController {
    class MessageCell: UITableViewCell, Reusable {

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.setupCell()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setupCell() {
            self.contentView.addSubview(self.view)
            self.view.addDropShadow()
        }

        internal lazy var view: UIView = {
            let view = UIView()
            view.roundCorners([.bottomLeft, .bottomRight, .topLeft], radius: 10)
            return view
        }()

        internal lazy var lblMessage: BaseAppLabel = {
            let label = BaseAppLabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()

        internal func prepareForDisplay(text: String) {
            self.lblMessage.attributedText = NSAttributedString(
                string: text,
                attributes: Style.body)
        }
    }

    final class MessageOutgoingCell: MessageCell {
        override func setupCell() {
            super.setupCell()

            self.view.autoPinEdge(toSuperviewEdge: .top, withInset: Style.padding.s, relation: .equal)
            self.view.autoPinEdge(toSuperviewEdge: .left, withInset: Style.padding.l, relation: .greaterThanOrEqual)
            self.view.autoPinEdge(toSuperviewEdge: .right, withInset: 0, relation: .greaterThanOrEqual)
            self.view.autoPinEdge(toSuperviewEdge: .bottom, withInset: Style.padding.s, relation: .equal)

            self.view.addSubview(self.lblMessage)
            self.lblMessage.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(all: Style.padding.s))
        }

        override func prepareForDisplay(text: String) {
            super.prepareForDisplay(text: text)

            self.lblMessage.textAlignment = .right
            self.view.backgroundColor = UIColor.cyan
        }
    }

    final class MessageIncomingCell: MessageCell {
        override func setupCell() {
            super.setupCell()

            self.view.autoPinEdge(toSuperviewEdge: .top, withInset: Style.padding.s, relation: .equal)
            self.view.autoPinEdge(toSuperviewEdge: .right, withInset: Style.padding.l, relation: .greaterThanOrEqual)
            self.view.autoPinEdge(toSuperviewEdge: .left, withInset: 0, relation: .greaterThanOrEqual)
            self.view.autoPinEdge(toSuperviewEdge: .bottom, withInset: Style.padding.s, relation: .equal)

            self.view.addSubview(self.lblMessage)
            self.lblMessage.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(all: Style.padding.s))
        }

        override func prepareForDisplay(text: String) {
            super.prepareForDisplay(text: text)

            self.lblMessage.textAlignment = .left
            self.view.backgroundColor = UIColor.green
        }
    }
}
