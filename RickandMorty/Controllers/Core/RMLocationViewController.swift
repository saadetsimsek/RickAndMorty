//
//  RMLocationViewController.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 15/12/2023.
//

import UIKit

///Controller to show and search for location
final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Location"
        addSearchButton()
        
    }
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch(){
        
    }

   
}
