//
//  UIStackView+extension.swift
//  DiaryOfObservation
//
//  Created by 김상진 on 2021/07/10.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
