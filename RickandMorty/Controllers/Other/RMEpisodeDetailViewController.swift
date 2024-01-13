//
//  RMEpisodeDetailViewController.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 24/12/2023.
//

import UIKit

///VC to show details about single episode
class RMEpisodeDetailViewController: UIViewController{
    
    private let viewModel: RMEpisodeDetailViewViewModel
    
    private let detailView = RMEpisodeDetailView()
    
//MARK: - Init
    
    init(url: URL?){
        self.viewModel = RMEpisodeDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Episode"
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        addConstraits()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, 
                                                            target: self,
                                                            action: #selector(didTapShare))
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
