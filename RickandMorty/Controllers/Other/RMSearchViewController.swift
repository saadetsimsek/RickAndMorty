//
//  RMSearchViewController.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 01/01/2024.
//

import UIKit

//configurable controller to search
final class RMSearchViewController: UIViewController {
    
    struct Config{
        enum Typee {
            case character
            case episode
            case location
        }
        let type: Typee
    }

    private let config: Config
    
    init(config: Config){
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        view.backgroundColor = .systemBackground
    }
}
