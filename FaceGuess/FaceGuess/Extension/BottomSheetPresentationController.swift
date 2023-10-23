//
//  BottomSheetPresentationController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//
import UIKit
class BottomSheetPresentationController: UIPresentationController {
    var height: CGFloat = 0.0

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat) {
        self.height = height
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect() }
        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }
}

