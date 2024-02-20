//
//  RMSearchResultsView.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 20/02/2024.
//

import UIKit

/// Show search results UI(table or collection as needed)
final class RMSearchResultsView: UIView {
    
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

    //MARK: -Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addConstraints()
        addSubviews(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func processViewModel(){
        guard let viewModel = viewModel else {return}
        
        switch viewModel {
        case .characters(let viewModels):
            setUpCollectionView()
        case .episodes(let viewModels):
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView()
        }
    }
    
    private func setUpCollectionView(){
        
    }
    
    private func setUpTableView(){
        tableView.isHidden = false
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
        tableView.backgroundColor = .yellow
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}
