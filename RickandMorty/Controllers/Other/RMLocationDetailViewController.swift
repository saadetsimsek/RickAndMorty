//
//  RMLocationDetailViewController.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 15/02/2024.
//

import UIKit


///VC to show details about single episode
final class RMLocationDetailViewController: UIViewController{
    
    private let viewModel: RMLocationDetailViewViewModel
    
    private let detailView = RMLocationDetailView()
    
//MARK: - Init
    
    init(location: RMLocation){
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Location"
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.delegate = self
        
        addConstraits()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
    
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }
    
    @objc private func didTapShare(){
        
    }
    
    private func addConstraits(){
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

//MARK: - View Model Delegate
extension RMLocationDetailViewController: RMLocationDetailViewViewModelDelegate{
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
    
    
    
}

//MARK: - View Delegate
extension RMLocationDetailViewController: RMLocationDetailViewDelegate{
    func rmLocationDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

