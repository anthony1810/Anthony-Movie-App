//
//  Rx+Extension.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 25/03/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

extension Reactive where Base: UILabel {
    public func numberOfline() -> Binder<Int> {
        return Binder(self.base) { label, count -> Void in
            label.numberOfLines = count
            label.setNeedsLayout()
        }
    }
}


