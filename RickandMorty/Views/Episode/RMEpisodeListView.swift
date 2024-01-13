//
//  RMEpisodeListView.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 24/12/2023.
//

import UIKit

protocol EpisodeListViewDelegate: AnyObject {
    func episodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode)
}

// view that handles showing list or episodes, loader, etc

final class RMEpisodeListView: UIView {
    
    public weak var delegate: EpisodeListViewDelegate?
    
    private let viewModel = RMEpisodeListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    //MARK - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubview(spinner)
        addSubview(collectionView)
        
        addConstraints()
        
        spinner.startAnimating()
        
        viewModel.delegate = self
        
        viewModel.fetchEpisodes()
    
        setUpCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpCollectionView(){
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        
   
    }
    
}

extension RMEpisodeListView: EpisodeListViewViewModelDelegate {
    func didLoadMoreEpisode(with newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates{
            
            self.collectionView.insertItems(at: newIndexPath)
        }
    }
    
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.episodeListView(self, didSelectEpisode: episode)
    }
    
    func didLoadInitialEpisodes() {
        
        spinner.stopAnimating()
        
        collectionView.isHidden = false
        collectionView.reloadData() // initial fetch
        UIView.animate(withDuration: 0.4){
            self.collectionView.alpha = 1
        }
        
    }
    
}
