//
//  HomeHeaderView.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 13/09/2022.
//

import UIKit

class HomeHeaderView: UICollectionReusableView {

    @IBOutlet weak var lblLastVisitedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(to data: HomeHeaderViewModelType) {
        rx.disposeBag.insert(
            data.lastVisitedDateString.drive(lblLastVisitedDate.rx.text)
        )
    }
    
}
