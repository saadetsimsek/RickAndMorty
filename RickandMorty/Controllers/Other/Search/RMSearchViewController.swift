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
            
            var endpoint: RMEndpoint{
                switch self {
                case .character:
                    return .character
                case .episode:
                    return .episode
                case .location:
                    return .location
                }
            }
            
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

//   private let config: Config
    private let viewModel: RMSearchViewViewModel
    private let searchView: RMSearchView
    
    init(config: Config){
      //  self.config = config
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstraits()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapExecuteSearch))
        searchView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchView.presentKeyboard()
    }
    
    @objc private func didTapExecuteSearch(){
        viewModel.executeSearch()
    }
    
    private func addConstraits(){
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RMSearchViewController: RMSearchViewDelegate {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        let vc = RMSearchOptionPickerViewController(option: option) {[weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        vc.sheetPresentationController?.detents = [.medium()]//Yani, kullanıcı sayfayı açtığında veya kapatırken, sayfanın ekranın ortasında yer alacağını belirtir.Uyguamada search- status(dynamicoptiona) basıldığında aktifleşir aktifleşir
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
    }
}
