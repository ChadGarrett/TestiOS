//
//  MentionViewController.swift
//  Testios
//
//  Created by Chad Garrett on 2020/02/10.
//  Copyright © 2020 Personal. All rights reserved.
//

import SwiftyBeaver
import SZMentionsSwift
import UIKit

final class Message {
    let text: String

    var mentions: [SZMentionsSwift.Mention] = []

    init(text: String) {
        self.text = text
    }

    internal func addMentions(_ mentions: [SZMentionsSwift.Mention]) {
        self.mentions = mentions
    }
}

final class Participant {
    let key: UUID
    let name: String

    init(name: String) {
        self.key = UUID()
        self.name = name
    }
}

final class MentionViewController: AppViewController {

    // MARK: Properties

    private var messages: [Message] = [
        Message(text: "Hello, how are you?"),
        Message(text: "Good, and you?"),
        Message(text: "The weather is good today."),
        Message(text: "I hadn't noticed.")
        ] {
        didSet { self.messagesDidUpdate() }
    }

    private var participants: [Participant] = []

    private var participantList: UIAlertController?

    /// Style for text inside the textview (Only applied if mentions are enabled)
    private var txtStyle: [AttributeContainer] {
        return [
            ChatTextBoxStyle(.font, value: UIFont.systemFont(ofSize: Style.fontSize.m)),
            ChatTextBoxStyle(.foregroundColor, value: UIColor.black)
        ]
    }

    /// Style for mentions inside the textview
    private func mentionTextStyle(_ mention: CreateMention?) -> [AttributeContainer] {
        return [
            ChatTextBoxStyle(.font, value: UIFont.systemFont(ofSize: Style.fontSize.m+1)),
            ChatTextBoxStyle(.foregroundColor, value: UIColor.blue)
        ]
    }

    private lazy var mentionListener: MentionListener = MentionListener(
        mentionsTextView: self.vwText,
        mentionTextAttributes: self.mentionTextStyle,
        defaultTextAttributes: self.txtStyle,
        spaceAfterMention: true,
        hideMentions: self.hideMentions,
        didHandleMentionOnReturn: self.didHideMentionOnReturn,
        showMentionsListWithString: self.showMentionsListWithString)

    // MARK: Setup

    override func setupView() {
        super.setupView()

        self.setupLayout()
        self.setupParticipants()
        self.setupMentions()
    }

    private func setupLayout() {
        self.title = "Mentions"

        self.view.addSubview(self.tableView)
        self.view.addSubview(self.vwText)
        self.view.addSubview(self.btnSend)

        self.tableView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(all: Style.padding.l), excludingEdge: .bottom)

        self.vwText.autoPinEdge(.top, to: .bottom, of: self.tableView, withOffset: Style.padding.m)
        self.vwText.autoPinEdge(toSuperviewEdge: .left, withInset: Style.padding.l)
        self.vwText.autoPinEdge(toSuperviewEdge: .right, withInset: Style.padding.l)
        self.vwText.autoSetDimension(.height, toSize: 150)

        self.btnSend.autoPinEdge(.top, to: .bottom, of: self.vwText, withOffset: Style.padding.m)
        self.btnSend.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(all: Style.padding.l), excludingEdge: .top)
    }

    private func setupParticipants() {
        self.participants = [
            Participant(name: "Troy"),
            Participant(name: "Abed"),
            Participant(name: "Jeff"),
            Participant(name: "Britta"),
            Participant(name: "Annie"),
            Participant(name: "Pierce"),
            Participant(name: "Shirley")
        ]
    }

    private func setupMentions() {
        self.mentionListener.reset()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        DispatchQueue.main.async { [tableView] in
            tableView.reloadData()
        }
    }

    // MARK: Actions

    @objc private func onSend() {
        guard let text = self.vwText.text.trimmed.nonEmpty
            else { return }

        let mentions = self.mentionListener.mentions
        mentions.forEach { SwiftyBeaver.debug("\($0.object) \($0.range)") }

        let message: Message = Message(text: text)
        message.addMentions(mentions)
        self.messages.append(message)
        self.vwText.text = ""
        self.mentionListener.reset()
    }

    private func onMention(_ participant: Participant) {
        let name: String = "@\(participant.name)"
        let mention: Mention = Mention(name, key: participant.key)
        self.mentionListener.addMention(mention)
    }

    // MARK: Property listeners

    private func messagesDidUpdate() {
        let lastRow: Int = (!messages.isEmpty) ? self.messages.count-1 : 0
        let lastIndexPath: IndexPath = IndexPath(row: lastRow, section: 0)

        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }

    private func hideMentions() {
        self.participantList?.dismiss(animated: true, completion: nil)
    }

    private func didHideMentionOnReturn() -> Bool {
        return true
    }

    private func showMentionsListWithString(name: String, delimiter: String) {
        let list = self.getParticipantList()
        self.participantList = list

        self.navigationController?.present(
            list,
            animated: true,
            completion: nil)
    }

    private func getParticipantList() -> UIAlertController {
        let actSheet = UIAlertController(title: "Mention", message: "Select a person to mention", preferredStyle: .alert)

        self.participants.forEach { (participant) in
            actSheet.addAction(UIAlertAction(
                title: participant.name,
                style: .default,
                handler: { _ in self.onMention(participant) }))
        }

        actSheet.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { _ in }))

        return actSheet
    }

    // MARK: Subviews

    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.register(cellType: MessageOutgoingCell.self)
        tableView.register(cellType: MessageIncomingCell.self)
        tableView.register(cellType: BlankTableCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var vwText: UITextView = {
        let textView: UITextView = UITextView()
        textView.text = "Hello"
        textView.typingAttributes = Style.callout
        textView.addBorder(color: .black, width: 2)
        textView.autocapitalizationType = .sentences
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(insetHorizontal: Style.padding.xxs, insetVertical: Style.padding.s)
        return textView
    }()

    private lazy var btnSend: GenericButton = {
        let button = GenericButton("Send")
        button.addTarget(self, action: #selector(onSend), for: .touchUpInside)
        button.backgroundColor = .greenSea
        button.disabledBackgroundColor = .green
        return button
    }()
}

extension MentionViewController: UITextViewDelegate {}

extension MentionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = self.messages.item(at: indexPath.row)
            else { return self.getBlankTableCell(for: indexPath) }

        return self.getMessageCell(for: indexPath, with: message)
    }

    private func getBlankTableCell(for indexPath: IndexPath) -> UITableViewCell {
        return self.tableView.dequeueReusableCell(for: indexPath, cellType: BlankTableCell.self)
    }

    private func getMessageCell(for indexPath: IndexPath, with message: Message) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell: MessageOutgoingCell = self.tableView.dequeueReusableCell(for: indexPath)
            cell.prepareForDisplay(text: message.text)
            return cell
        } else {
            let cell: MessageIncomingCell = self.tableView.dequeueReusableCell(for: indexPath)
            cell.prepareForDisplay(text: message.text)
            return cell
        }
    }
}

extension MentionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let message = self.messages.item(at: indexPath.row)
            else { return }

        SwiftyBeaver.verbose("Mentions: \n \(message.mentions)")
    }
}

final class Mention: CreateMention {
    var name: String
    var key: UUID

    var startIndex: Int = 0
    var length: Int = 0

    init(_ name: String, key: UUID) {
        self.name = name
        self.key = key
    }
}

final class ChatTextBoxStyle: AttributeContainer {
    var name: NSAttributedString.Key

    var value: Any

    init(_ key: NSAttributedString.Key, value: Any) {
        self.name = key
        self.value = value
    }
}
