//
//  UIStackView+Extensions.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 25/03/2022.
//

import UIKit

extension UIStackView {
    
    func removeAllArrangedView() {
        for item in arrangedSubviews {
            removeArrangedSubview(item)
            NSLayoutConstraint.deactivate(item.constraints)
            item.removeFromSuperview()
        }
    }
}
