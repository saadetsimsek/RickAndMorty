//
//  RMSearchResultViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 19/02/2024.
//

import Foundation

/*protocol RMSearchResultsRepresentable{
    associatedtype ResultType
    
    var results: [ResultType] { get }
}
*/
final class RMSearchResultViewModel{ //type
    
    public private(set) var results: RMSearchResultType
    private var next: String?
    
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public private(set) var isLoadingMoreResults = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public func fetchAdditionalLocations(completion: @escaping (RMLocationTableViewCellViewModel) -> Void){
        guard !isLoadingMoreResults else{
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else{
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else{
            isLoadingMoreResults = false
            return
        }
        
        switch results {
        case .characters(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
                guard let strongSelf = self else{
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.next = info.next // Capture new pagination url
                    
                    let additionalLocations = moreResults.compactMap({
                        return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                                      characterStatus: $0.status,
                                                                      characterImageUrl: URL(string: $0.image))
                    })
                    var newResults: [RMCharacterCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalLocations
                    strongSelf.results = .characters(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        
                        //Notify via callback
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .episodes(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let strongSelf = self else{
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.next = info.next // Capture new pagination url
                    
                    let additionalResults = moreResults.compactMap({
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                    })
                    var newResults: [RMLocationTableViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    strongSelf.results = .episodes(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        
                        //Notify via callback
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .locations:
            //Table case
            break
        }
        
 
    }
    
    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void){
        guard !isLoadingMoreResults else{
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else{
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else{
            isLoadingMoreResults = false
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else{
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next // Capture new pagination url
                
                let additionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                var newResults: [RMLocationTableViewCellViewModel] = []
                strongSelf.results = .locations(newResults)
                
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    
                    //Notify via callback
                    completion(newResults)
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreResults = false
            }
        }
    }
}

enum RMSearchResultType{
case characters([RMCharacterCollectionViewCellViewModel])
case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
case locations([RMLocationTableViewCellViewModel])
}
