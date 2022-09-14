//
//  MovieCell.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 10/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import DifferenceKit

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnFavorite: UIButton! {
        didSet {
            btnFavorite.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            btnFavorite.tintColor = .systemPink
        }
    }
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgArtwork.image = nil
        lblTitle.text = ""
        lblDesc.text = ""
        btnFavorite.setImage(nil, for: .normal)
        rx.clearDisposeBag()
    }
    
    func bind(to data: MovieCellModelType) {
        rx.disposeBag.insert(
            data.artworkURL.drive(imgArtwork.rx
                .imageURL(withPlaceholder: UIImage(named: R.image.artworkthumb.name),
                          options: [.transition(.fade(0.25)),
                                    .cacheMemoryOnly])),
            data.artworData.drive(imgArtwork.rx.imageData),
            data.name.drive(lblTitle.rx.text),
            data.desc.drive(lblDesc.rx.text),
            data.price.drive(lblPrice.rx.text),
            data.genre.drive(lblGenre.rx.text),
            data.isFavorite.map { !$0 }.drive(btnFavorite.rx.isHidden)
        )
    }

}
