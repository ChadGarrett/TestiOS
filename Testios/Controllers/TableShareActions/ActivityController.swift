//
//  ActivityController.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/25.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation
import SwiftyBeaver
import UIKit

/// Controller to test add custom activities to the share controller
final class ActivityController: AppViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        self.view.addSubview(self.lblHeading)
        self.lblHeading.autoPinEdge(toSuperviewEdge: .left, withInset: Style.padding.s)
        self.lblHeading.autoPinEdge(toSuperviewEdge: .right, withInset: Style.padding.s)
        self.lblHeading.autoAlignAxis(.horizontal, toSameAxisOf: self.view)

        self.view.addSubview(self.btnAction)
        self.btnAction.autoPinEdge(.top, to: .bottom, of: self.lblHeading, withOffset: Style.padding.m)
        self.btnAction.autoPinEdge(toSuperviewEdge: .left, withInset: Style.padding.s)
        self.btnAction.autoPinEdge(toSuperviewEdge: .right, withInset: Style.padding.s)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var lblHeading: UILabel = {
        let label = BaseAppLabel()
        label.attributedText = .init(
            string: """
                The func of this screen is to add custom activities to the activity view controller
                for the user to select when it is presented. This can allow the developer to give the user
                additional options from within the app, such as saving something from the app to notes,
                opening in another app, or triggering another flow within the current app
                """,
            attributes: Style.heading)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var btnAction: ConfirmButton = {
        let button = ConfirmButton("Action")
        button.addTarget(self, action: #selector(onShare), for: .touchUpInside)
        return button
    }()

    // Actions

    @objc private func onShare() {
        let customActivity1 = CustomActivity(title: "Action1", image: R.image.dogIcon60x60(), performAction: { _ in
            SwiftyBeaver.info("User selected option 1")
        })

        let customActivity2 = CustomActivity(title: "Shake the button", image: R.image.dogIcon60x60(), performAction: { _ in
            SwiftyBeaver.info("User selected option 2")
            self.btnAction.shake()
        })

        let customActivity3 = CustomActivity(title: "Make the screen green", image: R.image.dogIcon60x60(), performAction: { _ in
            SwiftyBeaver.info("User selected option 3")
            self.view.backgroundColor = .green

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.view.backgroundColor = .white
            }
        })

        let activityController = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: [customActivity1, customActivity2, customActivity3])

        // Examples of all the available options
        let exludedActivities: [UIActivity.ActivityType] = [
            .addToReadingList,
            .airDrop,
            .assignToContact,
            // .copyToPasteboard,
            .mail,
            .markupAsPDF,
            .message,
            .openInIBooks,
            .postToFacebook,
            .postToFlickr,
            .postToTencentWeibo,
            .postToTwitter,
            .postToVimeo,
            .print,
            .saveToCameraRoll
        ]

        activityController.excludedActivityTypes = exludedActivities
        self.present(activityController, animated: true, completion: nil)
    }
}

final class CustomActivity: UIActivity {
    var _activityTitle: String
    var _activityImage: UIImage?
    var activityItems = [Any]()
    var action: ([Any]) -> Void

    init(title: String, image: UIImage?, performAction: @escaping ([Any]) -> Void) {
        _activityTitle = title
        _activityImage = image
        action = performAction
        super.init()
    }

    override var activityTitle: String? {
        return _activityTitle
    }

    override var activityImage: UIImage? {
        return _activityImage
    }

    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType(rawValue: "com.yoursite.yourapp.activity")
    }

    override class var activityCategory: UIActivity.Category {
        return .action
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        self.activityItems = activityItems
    }

    override func perform() {
        action(activityItems)
        self.activityDidFinish(true)
    }
}
