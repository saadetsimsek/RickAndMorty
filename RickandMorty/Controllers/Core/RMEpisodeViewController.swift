//
//  RMEpisodeViewController.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 15/12/2023.
//

import UIKit

///Controller to show and search for episode
final class RMEpisodeViewController: UIViewController, EpisodeListViewDelegate{

    private let episodeListView = RMEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setUpView()
        addSearchButton()
        
    
    }
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch(){
        
    }
    
    private func setUpView(){
        
        episodeListView.delegate = self
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
    }
    
    //MARK: - EpisodeListViewDelegate
    
    func episodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        //open detail controller for thatcharacter
    
        let detailVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }

    

}
