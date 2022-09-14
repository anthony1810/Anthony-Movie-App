//
//  Kingfisher+Rx.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 19/03/2022.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

extension Reactive where Base: UIImageView {

    public var imageURL: Binder<URL?> {
        return self.imageURL(withPlaceholder: nil)
    }

    public func imageURL(withPlaceholder placeholderImage: UIImage?, options: KingfisherOptionsInfo? = []) -> Binder<URL?> {
        return Binder(self.base, binding: { (imageView, url) in
            imageView.kf.setImage(with: url,
                                  placeholder: placeholderImage,
                                  options: options,
                                  progressBlock: nil) { (result) in }
        })
    }
    
    public var imageData: Binder<Data?> {
        return Binder(self.base) { imageView, data in
            if let data = data {
                imageView.image = UIImage(data: data)
            }
        }
    }
}

