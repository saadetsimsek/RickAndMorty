//
//  RMEpisodeDetailViewViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 24/12/2023.
//

import UIKit

class RMEpisodeDetailViewViewModel {

    private let endpointUrl: URL?

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    private func fetchEpisodeData(){
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request,
                                 expecting: RMEpisode.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
}
