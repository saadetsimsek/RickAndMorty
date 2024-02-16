//
//  RMSearchViewController.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 01/01/2024.
//

import UIKit

//dynamic search option view
//render results
//render no results zero state
//searching / apı call

//configurable controller to search
final class RMSearchViewController: UIViewController {
    
    //configuration for search session
    struct Config{
        enum Typee {
            case character // name/ status/ gender
            case episode // allow name
            case location // name / type
            
            var title: String{
                switch self {
                case .character:
                    return "Search Characters"
                case .episode:
                    return "Search Location"
                case .location:
                    return "Search Episode"
                }
            }
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = config.type.title
        view.backgroundColor = .systemBackground
    }
}
