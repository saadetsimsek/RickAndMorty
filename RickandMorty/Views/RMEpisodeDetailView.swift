//
//  RMEpisodeDetailView.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 24/12/2023.
//

import UIKit

final class RMEpisodeDetailView: UIView {
    
    private var viewModel: RMEpisodeDetailViewViewModel?
    
    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        self.collectionView = createCollectionView()
        addConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraits(){
        NSLayoutConstraint.activate([
        ])
    }
    
    private func createCollectionView() ->UICollectionView{
        
    }
    
    public func configure(with viewModel: RMEpisodeDetailViewViewModel){
        self.viewModel = viewModel
    }
    
}
