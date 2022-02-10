//
//  MentionViewController.swift
//  Testios
//
//  Created by Chad Garrett on 2020/02/10.
//  Copyright © 2020 Personal. All rights reserved.
//

import RealmSwift
import SwiftyBeaver
import SZMentionsSwift
import UIKit

final class ChatAndMentionController: AppViewController {

    // MARK: Properties

    private var participants: [ChatParticipant] = []

    private var participantList: UIAlertController?

    /// Style for text inside the textview (Only applied if mentions are enabled)
    private var txtStyle: [SZMentionsSwift.AttributeContainer] {
        return [
            ChatTextBoxStyle(.font, value: UIFont.systemFont(ofSize: Style.fontSize.m)),
            ChatTextBoxStyle(.foregroundColor, value: UIColor.black)
        ]
    }

    /// Style for mentions inside the textview
    private func mentionTextStyle(_ mention: CreateMention?) -> [SZMentionsSwift.AttributeContainer] {
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

        self.dataProvider.start()
    }

    deinit {
        self.dataProvider.stop()
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

        self.tableView.scrollToBottom()
    }

    private func setupParticipants() {
        self.participants = [
            ChatParticipant(name: "Troy"),
            ChatParticipant(name: "Abed"),
            ChatParticipant(name: "Jeff"),
            ChatParticipant(name: "Britta"),
            ChatParticipant(name: "Annie"),
            ChatParticipant(name: "Pierce"),
            ChatParticipant(name: "Shirley")
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

    // MARK: Data

    private lazy var dataProvider: BaseDataProvider<ChatMessage> = {
        let provider = BaseDataProvider<ChatMessage>(
            bindTo: .tableView(self.tableView),
            basePredicate: .truePredicate,
            filter: .truePredicate,
            sort: [])
        provider.updateDelegate = self
        return provider
    }()

    // MARK: Actions

    @objc private func onSend() {
        guard let text = self.vwText.text.trimmed.nonEmpty
            else { return }

        // Gather the mentions in the chat message
        let mentions = self.mentionListener.mentions
        mentions.forEach { SwiftyBeaver.debug("\($0.object) \($0.range)") }

        // Build a new chat message
        let message: ChatMessage = ChatMessage()
        message.textContent = text
        message.senderName = self.participants.randomElement()?.name ?? ""

        // Add it to the store
        RealmInterface.add(object: message)

        // Reset
        self.vwText.text = ""
        self.mentionListener.reset()
    }

    private func onMention(_ participant: ChatParticipant) {
        let name: String = "@\(participant.name)"
        let mention: Mention = Mention(name, key: participant.key)
        self.mentionListener.addMention(mention)
    }

    // MARK: Property listeners

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

extension ChatAndMentionController: UITextViewDelegate {}

extension ChatAndMentionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.query().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = self.dataProvider.object(at: indexPath.row)
        else { return self.getBlankTableCell(for: indexPath) }

        return self.getMessageCell(for: indexPath, with: message)
    }

    private func getBlankTableCell(for indexPath: IndexPath) -> UITableViewCell {
        return self.tableView.dequeueReusableCell(for: indexPath, cellType: BlankTableCell.self)
    }

    private func getMessageCell(for indexPath: IndexPath, with message: ChatMessage) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell: MessageOutgoingCell = self.tableView.dequeueReusableCell(for: indexPath)
            cell.prepareForDisplay(text: message.textContent)
            return cell
        } else {
            let cell: MessageIncomingCell = self.tableView.dequeueReusableCell(for: indexPath)
            cell.prepareForDisplay(text: message.textContent)
            return cell
        }
    }
}

extension ChatAndMentionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let message = self.dataProvider.object(at: indexPath.row)
            else { return }

        SwiftyBeaver.verbose("Mentions: \n \(message)")
    }
}

extension ChatAndMentionController: DataProviderUpdateDelegate {
    func providerDataDidUpdate<F>(_ provider: BaseDataProvider<F>) where F: BaseObject {
        self.scrollToBottomOnNewMessage()
    }

    private func scrollToBottomOnNewMessage() {
        DispatchQueue.main.async {
            let lastRow: Int = (!self.dataProvider.query().isEmpty) ? self.dataProvider.query().count-1 : 0
            let lastIndexPath: IndexPath = IndexPath(row: lastRow, section: 0)
            self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
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

final class ChatTextBoxStyle: SZMentionsSwift.AttributeContainer {
    var name: NSAttributedString.Key

    var value: Any

    init(_ key: NSAttributedString.Key, value: Any) {
        self.name = key
        self.value = value
    }
}

extension UITableView {
    func scrollToBottom(of section: Int = 0) {
        let indexPath = IndexPath(row: self.numberOfRows(inSection: section)-1, section: section)
        self.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
