//
//  RMSearchResultsView.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 20/02/2024.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

/// Show search results UI(table or collection as needed)
final class RMSearchResultsView: UIView {
    
    weak var delagate: RMSearchResultsViewDelegate?
    
    private var viewModel: RMSearchResultViewModel? {
        didSet{
            self.processViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        //footer for loading
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    ///TableView viewModels
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    ///Collectionview ViewModel
    private var collectionViewCellViewModels: [any Hashable] = []

    //MARK: -Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addConstraints()
        addSubviews(tableView, collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func processViewModel(){
        guard let viewModel = viewModel else {return}
        
        switch viewModel.results {
        case .characters(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .episodes(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView(viewModels: viewModels)
        }
    }
    
    private func setUpCollectionView(){
        self.tableView.isHidden = true
        self.collectionView.isHidden = false
        collectionView.backgroundColor = .red
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        collectionView.isHidden = true
        self.locationCellViewModels = viewModels
        tableView.reloadData()
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}
//MARK: - Tableview delegate
extension RMSearchResultsView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.identifier, for: indexPath) as? RMLocationTableViewCell
        else {
            fatalError("Failed to dequeue RMLocationTableViewCell")
        }
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewModel = locationCellViewModels[indexPath.row]
        delagate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
}

extension RMSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // character / episode
        
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if let characterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel {
            //character cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: characterVM)
            return cell
        }
        
        //episode
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else{
            fatalError()
        }
        if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel {
            cell.configure(with: episodeVM)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell tap
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        
        let bounds = collectionView.bounds
        
        if currentViewModel is RMCharacterCollectionViewCellViewModel{
            //character size
            let width = UIDevice.isiPhone ? (bounds.width-30)/2: (bounds.width-50)/4
            return CGSize(width: width,
                          height: width * 1.5)
        }
        //episode
        let width = UIDevice.isiPhone ? bounds.width-20 : (bounds.width-50)/4
        return CGSize(width: width,
                      height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                                                                           for: indexPath) as? RMFooterLoadingCollectionReusableView else{
            fatalError("Unsupported")
        }
        if let viewModel = viewModel, viewModel.shouldShowLoadMoreIndicator{
            footer.startAnimating()
        }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let viewModel = viewModel, viewModel.shouldShowLoadMoreIndicator else{
            return .zero
        }
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }
    
}

//MARK: - ScrollView Delegate
extension RMSearchResultsView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleLocationPagination(scrollView: scrollView)
            if !locationCellViewModels.isEmpty {
                handleLocationPagination(scrollView: scrollView)
            }
            else{
                //CollectionView
                handleCharacterEpisodePagination(scrollView: scrollView)
            }
    }
    
    private func handleCharacterEpisodePagination(scrollView: UIScrollView){
        guard let viewModel = viewModel, !collectionViewCellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator, !viewModel.isLoadingMoreResults else{
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalConstentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalConstentHeight - totalScrollViewFixedHeight - 120){
                viewModel.fetchAdditionalResults{[weak self] newResults in
                    //Refresh table
                    guard let strongSelf = self else{
                        return
                    }
                    DispatchQueue.main.async {
                        strongSelf.tableView.tableFooterView = nil
                        let originalCount = strongSelf.collectionViewCellViewModels.count
                        let newCount = (newResults.count - originalCount)
                        let total = originalCount + newCount
                        let startingIndex = total - newCount
                        let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                            return IndexPath(row: $0, section: 0)
                        })
                        print("Should add more result cells for search results \(newResults.count)")
                        strongSelf.collectionViewCellViewModels = newResults
                        strongSelf.collectionView.insertItems(at: indexPathsToAdd)
                    }
                    
                }
            }
            t.invalidate()
        }
    }
    
    private func handleLocationPagination(scrollView: UIScrollView){
        guard let viewModel = viewModel,
              !locationCellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults else {
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                viewModel.fetchAdditionalLocations { [weak self] newResults in
                    // Refresh table
                    guard let strongSelf = self else{
                        return
                    }
                    strongSelf.tableView.tableFooterView = nil
                    let originalCount = strongSelf.collectionViewCellViewModels.count
                    let newCount = newResults.count
                    let total = originalCount + newCount
                    let startingIndex = total - newCount
                    let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                        return IndexPath(row: $0, section: 0)
                    })
                    self?.tableView.tableFooterView = nil
                    self?.locationCellViewModels = newResults
                    
                }
            }
            t.invalidate()
        }
    }
    
    private func showTableLoadingIndicator(){
        let footer = RMTableLoadingFooterView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: frame.size.width,
                                                            height: 100))
        tableView.tableFooterView = footer
    }
}
