//
//  ImageViewController.swift
//  Testios
//
//  Created by Chad Garrett on 2020/02/28.
//  Copyright © 2020 Personal. All rights reserved.
//

import Nuke
import SwiftyBeaver

/// Controller to test using Nuke to load and display images
final class ImageViewController: AppViewController {

    private let avatarUrlString = "https://i.pravatar.cc/300"

    override func setupView() {
        super.setupView()

        self.view.addSubview(self.imgView1)
        self.view.addSubview(self.imgView2)

        self.imgView1.autoPinEdge(toSuperviewEdge: .top)
        self.imgView1.autoPinEdge(toSuperviewEdge: .left)
        self.imgView1.autoPinEdge(toSuperviewEdge: .right)
        self.imgView1.autoSetDimension(.height, toSize: UIScreen.main.bounds.height/2)

        self.imgView2.autoPinEdge(.top, to: .bottom, of: self.imgView1)
        self.imgView2.autoPinEdge(toSuperviewEdge: .left)
        self.imgView2.autoPinEdge(toSuperviewEdge: .right)
        self.imgView2.autoPinEdge(toSuperviewEdge: .bottom)
        self.imgView2.autoSetDimension(.height, toSize: UIScreen.main.bounds.height/2)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Basic nuke usage
        if let url = URL(string: self.avatarUrlString) {
            Nuke.loadImage(with: url, into: self.imgView1)
        }

        // Most available options
        // TODO: Experiment with the image processors
        if let url = URL(string: self.avatarUrlString) {
            Nuke.loadImage(with: url, into: self.imgView2)
            Nuke.loadImage(
                with: url,
                options: .init(
                    placeholder: nil,
                    transition: .some(.fadeIn(duration: 0.5)),
                    failureImage: nil,
                    failureImageTransition: nil,
                    contentModes: nil,
                    tintColors: nil),
                into: self.imgView2,
                progress: { _, completed, total in
                    SwiftyBeaver.info("Image load at: \(completed)/\(total)")
                },
                completion: { result in
                    switch result {
                    case .success(let response):
                        SwiftyBeaver.info("Finished loading image")
                        SwiftyBeaver.verbose(response)

                    case .failure(let error):
                        SwiftyBeaver.error("Unable to load image", error.localizedDescription)
                    }
                })
        }
    }

    private lazy var imgView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var imgView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
}
