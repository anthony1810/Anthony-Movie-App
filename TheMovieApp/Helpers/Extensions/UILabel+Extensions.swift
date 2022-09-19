//
//  UILabel+Extensions.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 25/03/2022.
//

import UIKit

extension UILabel {
    /**
     Measure the size of some text
     */
    class func measure(text: String, font: UIFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = text
        measurementLabel.font = font
        return measurementLabel.intrinsicContentSize
    }
}

