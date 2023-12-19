//
//  ViewController.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 15/12/2023.
//

import UIKit

///Controller to show and search for characters
final class RMCharacterViewController: UIViewController, CharacterListViewDelegate {
    
    private let characterListView = CharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Characters"
        setUpView()
        
    
    }
    private func setUpView(){
        
        characterListView.delegate = self
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
    }
    
    //MARK: - CharacterListViewDelegate
    func characterListView(_ characterListView: CharacterListView, didSelectCharacter character: RMCharacter) {
        //open detail controller for thatcharacter
        
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
    
    
    /*      let request = RMRequest(endpoint: .character,
                                  pathComponenets: ["1"],
                                  queryParameters:
                                      [ URLQueryItem(name: "name", value: "rick"),
                                      URLQueryItem(name: "status", value: "alive")])
          print(request.url)
          
          RMService.shared.execute(request, expecting: RMCharacter.self) { result in
              switch result {
              case .success:
                  break
              case .failure(let error):
                  print(String(describing: error))
              }
          }
     */


}

