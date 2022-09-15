//
//  MovieDetailViewController.swift
//  TheMovieApp
//
//  Created by Anthony Tran on 11/09/2022.
//

import RxSwift
import RxCocoa
import XCoordinator
import DifferenceKit
import RxAppState

class MovieDetailViewController: BaseViewController, BindableType {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            /// register cell & header
            tableView.register(R.nib.movieDetailCell)
            
            /// setup table
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
            tableView.estimatedRowHeight = 400
            tableView.rowHeight = UITableView.automaticDimension
            tableView.dataSource = self
            tableView.separatorInset = UIEdgeInsets.zero
        }
    }
    
    internal var viewModel: MovieDetailViewModelType!
    internal var data = [MovieDataView]()
    private var dataInput: [MovieDataView] {
        get { return data }
        set {
            let changeset = StagedChangeset(source: data, target: newValue)
            tableView.reload(using: changeset, with: .fade)  { data in
                self.data = data
            }
        }
    }
    private var delegate: HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    internal func bindViewModel() {
        let input = MovieDetailInput(willAppear: rx.viewWillAppear, willDisappear: rx.viewWillDisappear)
        viewModel.transform(input: input)
        viewModel.output?.data
            .map { $0 as! MovieDataView }
            .drive(onNext: { [weak self] movie in
                self?.dataInput = [movie]
            })
            .disposed(by: rx.disposeBag)
        
        
    }

}

extension MovieDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.movieDetailCell,
                                                       for: indexPath)
                
        else { return UITableViewCell() }
        let data = data[indexPath.row]
        cell.bind(to: MovieDetailCellModel(with: data),
                  favoriteButtonTrigger: viewModel.output?.favoriteActionTrigger)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}

