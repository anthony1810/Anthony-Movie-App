//
//  ViewController.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 08/09/2022.
//

import UIKit
import RxCocoa
import RxSwift
import EmptyDataSet_Swift
import DifferenceKit
import Action
import Resolver
import RxAppState

class HomeViewController: BaseViewController, BindableType {
    
    /// Model control business logic of HomeViewController
    internal var viewModel: HomeViewModelType!
    
    /// Data driven in this view
    internal var data = [HomeViewModel.Section]()
    private var dataInput: [HomeViewModel.Section] {
        get { return data }
        set {
            let changeset = StagedChangeset(source: data, target: newValue)
            collectionView.reload(using: changeset) { data in self.data = data }
            collectionView.reloadEmptyDataSet()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var lblNotice: UILabel!
    @IBOutlet weak var btnArchive: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0

            collectionView.setCollectionViewLayout(layout, animated: false)
            collectionView.register(R.nib.movieCell)
            collectionView.register(R.nib.homeHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = R.string.localizable.homeTitle()
        
    }
    
    internal func bindViewModel() {
        let input = HomeInput(willAppear: rx.viewWillAppear,
                              searchTextDidChange: self.searchBar.rx.text.orEmpty.asObservable())
        viewModel.transform(input: input)
        
        /// Update Data if any changes
        viewModel.output?.reloadContent.drive(onNext: { [unowned self] section in
            self.dataInput = [section]
        })
        .disposed(by: rx.disposeBag)
        
        /// Show/hide notice label
        viewModel.output?.reloadContent
            .map { $0.elements.count > 0 ? true : false }
            .drive(lblNotice.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        viewModel.output?.reloadContent.drive(onNext: { [unowned self] section in
            guard let searchText = searchBar.text else { return }
            switch (section.elements.count, searchText.count) {
            case (0, 1...Int.max):
                lblNotice.text = R.string.localizable.homeNoticeNomatch()
            default:
                lblNotice.text = R.string.localizable.homeNoticeSearchnow()
            }
        })
        .disposed(by: rx.disposeBag)
            
        /// Action Binding
        if let unwrapTrigger = viewModel.output?.itemDetailTrigger {
            collectionView.rx.itemSelected
                .map { [unowned self] index -> MovieDataView in
                    return (self.data[index.section].elements[index.row] )
            }
            .bind(to: unwrapTrigger)
            .disposed(by: rx.disposeBag)
        }
        
        if let unwrapTrigger = viewModel.output?.archiveButtonTrigger {
            btnArchive.rx.tap
                .bind(to: unwrapTrigger)
                .disposed(by: rx.disposeBag)
        }
        
        viewModel.error.drive(self.error).disposed(by: rx.disposeBag)
    }
}

//MARK: - DataSource
extension HomeViewController: UICollectionViewDataSource {
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
        cell.bind(to: MovieCellModel(with: movieModel),
                  favoriteButtonTrigger: self.viewModel.output?.favoriteButtonTrigger)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                          withReuseIdentifier: R.reuseIdentifier.homeHeaderView,
                                                                          for: indexPath),
               let viewModelOutput = viewModel.output {
                view.bind(to: HomeHeaderViewModel(with: viewModelOutput))
                return view
            }
        }
        
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
    
    
}
