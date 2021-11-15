//
//  ActivityController.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/25.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation
import UIKit

final class ActivityController: AppViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        self.view.addSubview(self.btnAction)
        self.btnAction.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(all: Style.padding.xl))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var btnAction: ConfirmButton = {
        let button = ConfirmButton("Action")
        button.addTarget(self, action: #selector(onShare), for: .touchUpInside)
        return button
    }()

    // Actions

    @objc private func onShare() {
        let customActivity1 = CustomActivity(title: "Action1", image: R.image.dogIcon60x60(), performAction: { _ in
            print("yay")
        })

        let customActivity2 = CustomActivity(title: "Action2", image: R.image.dogIcon60x60(), performAction: { _ in
            print("yay")
        })

        let customActivity3 = CustomActivity(title: "Action3", image: R.image.dogIcon60x60(), performAction: { _ in
            print("yay")
        })

        let activitController = UIActivityViewController(activityItems: [], applicationActivities: [customActivity1, customActivity2, customActivity3])

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

        activitController.excludedActivityTypes = exludedActivities
        self.present(activitController, animated: true, completion: nil)
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
