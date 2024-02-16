//
//  RMLocationViewController.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 15/12/2023.
//

import UIKit

///Controller to show and search for location
final class RMLocationViewController: UIViewController {
    
    private let primaryView = RMLocationView()
    
    private let viewModel = RMLocationViewViewModel()
    
    //MARK: - lifecycle

    override  func viewDidLoad() {
        super.viewDidLoad()

        primaryView.delegate = self
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Location"
        addSearchButton()
        addConstraits()
        viewModel.delegate = self
        viewModel.fetchLocations()
        
        
    }
    private func addConstraits(){
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch(){
        
    }

}
//MARK: - LocationViewModel Delegate
extension RMLocationViewController: RMLocationViewViewModelDelegate {
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
}

//MARK: - LocatinView delegate
extension RMLocationViewController: RMLocationViewDelegate {
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
