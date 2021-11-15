//
//  HomeViewController.swift
//  Testios
//
//  Created by Chad Garrett on 2019/07/15.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import SkeletonView

final class HomeViewController: AppViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.isSkeletonable = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.lblHeading)
        self.view.addSubview(self.lblBody)
        self.view.addSubview(self.btnToggle)
        
        self.imageView.autoPinEdge(toSuperviewSafeArea: .top, withInset: Style.padding.s)
        self.imageView.autoPinEdge(toSuperviewEdge: .left, withInset: Style.padding.s)
        self.imageView.autoPinEdge(toSuperviewEdge: .right, withInset: Style.padding.s)
        self.imageView.autoSetDimension(.height, toSize: UIScreen.main.bounds.height/2)
        
        self.lblHeading.autoPinEdge(.top, to: .bottom, of: self.imageView, withOffset: Style.padding.s)
        self.lblHeading.autoPinEdge(toSuperviewEdge: .left, withInset: Style.padding.s)
        self.lblHeading.autoPinEdge(toSuperviewEdge: .right, withInset: Style.padding.s)
        
        self.lblBody.autoPinEdge(.top, to: .bottom, of: self.lblHeading, withOffset: Style.padding.s)
        self.lblBody.autoPinEdge(toSuperviewEdge: .left, withInset: Style.padding.s)
        self.lblBody.autoPinEdge(toSuperviewEdge: .right, withInset: Style.padding.s)
        
        self.btnToggle.autoPinEdge(toSuperviewEdge: .left, withInset: Style.padding.s)
        self.btnToggle.autoPinEdge(toSuperviewEdge: .right, withInset: Style.padding.s)
        self.btnToggle.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: Style.padding.s)
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: R.image.yogi_Bear())
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private lazy var lblHeading: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.example_heading()
        label.isSkeletonable = true
        return label
    }()
    
    private lazy var lblBody: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = R.string.localizable.example_body()
        label.isSkeletonable = true
        return label
    }()
    
    private lazy var btnToggle: GenericButton = {
        let button = GenericButton("Toggle")
        button.backgroundColor = Style.colors.peterRiver
        button.addTarget(self, action: #selector(onToggle), for: .touchUpInside)
        return button
    }()
    
    // Actions
    
    @objc private func onToggle() {
        if self.imageView.isSkeletonActive {
            self.view.hideSkeleton()
        } else {
            let gradient = SkeletonGradient(baseColor: UIColor.silver)
            self.view.showAnimatedGradientSkeleton(usingGradient: gradient)
        }
    }
}
