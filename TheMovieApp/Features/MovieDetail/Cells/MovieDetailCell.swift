//
//  MovieDetailCell.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 12/09/2022.
//

import UIKit
import RxSwift

class MovieDetailCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblLongDesc: UILabel!
    
    //MARK: - Cell Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgArtwork.image = nil
        lblTitle.text = ""
        lblLongDesc.text = ""
        btnFavorite.setImage(nil, for: .normal)
        rx.clearDisposeBag()
    }
    
    /// Binding Data to Cell
    /// - Parameters:
    ///   - data: Model which hold business logic of this cell
    ///   - favoriteButtonTrigger: action binding to favorite button
    func bind(to data: MovieDetailCellModel, favoriteButtonTrigger: AnyObserver<Data>?) {
        rx.disposeBag.insert(
            data.artworkURL.drive(imgArtwork.rx
                .imageURL(withPlaceholder: UIImage(named: R.image.artworkthumb.name),
                          options: [.transition(.fade(0.25)),
                                    .cacheMemoryOnly])),
            data.artworkData.drive(imgArtwork.rx.imageData),
            data.name.drive(lblTitle.rx.text),
            data.longDesc.drive(lblLongDesc.rx.text),
            data.price.drive(lblPrice.rx.text),
            data.genre.drive(lblGenre.rx.text),
            data.isFavorite.drive(onNext: { [weak self] isFavorite in
                guard let `self` = self else { return }
                switch isFavorite {
                case true:
                    self.btnFavorite.setTitle(R.string.localizable.movieDetailRemoveFromFavorite(), for: .normal)
                case false:
                    self.btnFavorite.setTitle(R.string.localizable.movieDetailAddToFavorite(), for: .normal)
                }
            })
        )
        
        if let unwrapTrigger = favoriteButtonTrigger {
            btnFavorite.rx.tap
                .map { self.imgArtwork.image?.jpegData(compressionQuality: 1.0)}
                .filterNil()
                .bind(to: unwrapTrigger)
                .disposed(by: rx.disposeBag)
        }
    }
    
}
