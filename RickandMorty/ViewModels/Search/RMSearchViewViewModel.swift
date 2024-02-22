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
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    
    private var searchText = ""
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    private var searchResultHandler: ((RMSearchResultViewModel)-> Void)?
    
    private var noResultsHandler: (() -> Void)?
    
    private var searchResultModel: Codable?
    
    //MARK: -Init
    init(config: RMSearchViewController.Config){
        self.config = config
    }
    
    //MARK: - Public
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption){
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void){
        self.optionMapUpdateBlock = block
    }
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void){
        self.searchResultHandler = block
    }
    
    public func registerNoResultsHandler(_ block: @escaping ()-> Void){
        self.noResultsHandler = block
    }
    
    public func set(query text: String){
        self.searchText = text
    }
    
    public func executeSearch(){
        //create Request based on filters
        //status= alive
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        //build argumants
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
            ]
        //Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({_, element in
            let key: RMSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        //create request
        let request = RMRequest(endpoint: config.type.endpoint,
                                queryParameters: queryParams )
      
   
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        }
        
    }
    
    public func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else{
            return nil
        }
        return searchModel.results[index]
    }
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest){
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            //notify view of results, no results, or error
            switch result {
            case .success(let model):
                //episode, characters: Collectionview, location: Tableview
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }
    
    private func processSearchResults(model: Codable){
        var resultsVM: RMSearchResultType?// enum dizi içerisinde olmalı
        var nextUrl: String?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.image
                                                              , characterStatus: $0.status, characterImageUrl: URL(string: $0.image))
            }))
            nextUrl = characterResults.info.next
        }
        else if let episodeResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodeResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
            nextUrl = episodeResults.info.next
        }
        else if let locationResults = model as? RMGetAllLocationsResponse{
            resultsVM = .locations(locationResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
            nextUrl = locationResults.info.next
        }
        if let results = resultsVM{
            self.searchResultModel = model
            let vm = RMSearchResultViewModel(results: results, next: nextUrl)
            self.searchResultHandler?(vm)
        }
        else{
            //fallback error
            handleNoResults()
        }
    }
    
    private func handleNoResults(){
        noResultsHandler?()
    }
    
  
}
