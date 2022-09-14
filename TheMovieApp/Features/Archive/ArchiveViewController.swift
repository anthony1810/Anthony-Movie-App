//
//  ArchiveViewController.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 14/09/2022.
//

import UIKit
import RxCocoa
import RxSwift
import EmptyDataSet_Swift
import DifferenceKit
import Action
import Resolver
import RxAppState

class ArchiveViewController: BaseViewController, BindableType {

    @IBOutlet weak var lblNotice: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0

            collectionView.setCollectionViewLayout(layout, animated: false)
            collectionView.register(R.nib.movieCell)
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    internal var viewModel: ArchiveViewModelType!
    internal var data = [ArchiveViewModel.Section]()
    private var dataInput: [ArchiveViewModel.Section] {
        get { return data }
        set {
            let changeset = StagedChangeset(source: data, target: newValue)
            collectionView.reload(using: changeset) { data in self.data = data }
            collectionView.reloadEmptyDataSet()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = R.string.localizable.archiveTitle()
    }
    
    internal func bindViewModel() {
        let input = ArchiveInput(willAppear: rx.viewWillAppear)
        viewModel.transform(input: input)
        
        //control view data
        viewModel.output?.reloadContent.drive(onNext: { [unowned self] section in
            self.dataInput = [section]
        })
        .disposed(by: rx.disposeBag)
        
        //Control Notice Label
        viewModel.output?.reloadContent
            .map { $0.elements.count > 0 ? true : false }
            .drive(lblNotice.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        viewModel.output?.reloadContent.drive(onNext: { [unowned self] section in
            switch (section.elements.count) {
            case (1...Int.max):
                lblNotice.text = ""
            default:
                lblNotice.text = R.string.localizable.archiveNoticeYourfavorite()
            }
        })
        .disposed(by: rx.disposeBag)
        
        //show movie detail here
        if let unwrapTrigger = viewModel.output?.itemDetailTrigger {
            collectionView.rx.itemSelected
                .map { [unowned self] index -> MovieDataView in
                    return (self.data[index.section].elements[index.row] )
            }
            .bind(to: unwrapTrigger)
            .disposed(by: rx.disposeBag)
        }
        
        viewModel.error.drive(self.error).disposed(by: rx.disposeBag)
    }

}

extension ArchiveViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier.movieCell,
                                                            for: indexPath) as? MovieCell
              
        else { return UICollectionViewCell() }
        let movieModel = data[indexPath.section].elements[indexPath.row]
        cell.bind(to: MovieCellModel(with: movieModel))
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension ArchiveViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 126)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

