//
//  RMEpisodeDetailViewViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 24/12/2023.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {

    private let endpointUrl: URL?
    
    private var dataTuple: (RMEpisode, [RMCharacter])?{
        didSet{
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    

    //MARK: - Init

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        
    }
    
    
    //MARK: - Private
    
    ///Fetch backking episode model
    public func fetchEpisodeData(){
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request,
                                 expecting: RMEpisode.self) {[weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    //karakter urli elde etme
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        //10 of parallel request
        
        //Notified once all done
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        
        for request in requests {
            group.enter() // +20
            RMService.shared.execute(request, expecting: RMCharacter.self) {  result in
                defer{
                    group.leave() //-20
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure(let failure):
                    break
                }
            }
        }
        group.notify(queue: .main){
            self.dataTuple = (
                episode,
                characters
            )
        }
    }
}
