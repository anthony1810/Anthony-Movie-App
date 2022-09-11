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

class HomeViewController: BaseViewController, BindableType {

    internal var viewModel: HomeViewModelType!
    internal var data = [HomeViewModel.Section]()
    private var dataInput: [HomeViewModel.Section] {
        get { return data }
        set {
            let changeset = StagedChangeset(source: data, target: newValue)
            collectionView.reload(using: changeset) { data in self.data = data }
            collectionView.reloadEmptyDataSet()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
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
            
//            collectionView.emptyDataSetView { [weak self] (view) in
//                guard let `self` = self else { return }
//                EmptyViewType.titles(frame: self.collectionView.bounds).makeCustomView(onView: view)
//            }
        }
    }
    
    internal func bindViewModel() {
        let input = HomeInput(searchTextDidChange: self.searchBar.rx.text.orEmpty.asObservable())
        viewModel.transform(input: input)
        
        viewModel.output?.reloadContent.drive(onNext: { [unowned self] section in
            self.dataInput.append(section)
        }).disposed(by: rx.disposeBag)
        
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
        cell.bind(to: MovieCellModel(with: movieModel))
        return cell
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
}
