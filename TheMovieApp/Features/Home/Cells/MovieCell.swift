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
    @IBOutlet weak var btnFavorite: UIButton!
    
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
                .imageURL(withPlaceholder: nil,
                          options: [.transition(.fade(0.25)),
                                    .cacheMemoryOnly])),
            data.name.drive(lblTitle.rx.text),
            data.desc.drive(lblDesc.rx.text)
        )
    }

}
