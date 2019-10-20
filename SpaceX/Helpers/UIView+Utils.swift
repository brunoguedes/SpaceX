//
//  UIView+Utils.swift
//  SpaceX
//
//  Created by Bruno Guedes on 20/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import UIKit

extension UIView {
    func addPinned(subView: UIView, leading: CGFloat = 0.0, trailing: CGFloat = 0.0, top: CGFloat = 0.0, bottom: CGFloat = 0.0) {
        addSubViewWithoutAutoresizingMaskIntoConstraints(subView: subView)
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading),
            subView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailing),
            subView.topAnchor.constraint(equalTo: topAnchor, constant: top),
            subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom)
            ])
    }
    
    func addSubViewWithoutAutoresizingMaskIntoConstraints(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.clipsToBounds = true
        addSubview(subView)
    }
}
