//
//  ImageViewController.swift
//  Testios
//
//  Created by Chad Garrett on 2020/02/28.
//  Copyright © 2020 Personal. All rights reserved.
//

import Nuke

final class ImageViewController: AppViewController {

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

        if let url = URL(string: "https://staging-img.kalido-api.com/kalido-media/2801/290520190233164F31B053-2F81-40FA-A495-B003F277FB2B.jpg") {
            Nuke.loadImage(with: url, into: self.imgView1)
        }

        if let url = URL(string: "https://staging-img.kalido-api.com/kalido-media/auto-generated-kalido/lauren-mancke-63448-unsplash.jpg") {
            Nuke.loadImage(with: url, into: self.imgView2)
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
