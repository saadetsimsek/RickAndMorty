//
//  RMSearchViewViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 16/02/2024.
//

import Foundation

// Responsibilities
// - show search results
// - show no results view
// - kick off API requests

final class RMSearchViewViewModel{
    
    let config: RMSearchViewController.Config
    
    init(config: RMSearchViewController.Config){
        self.config = config
    }
}
