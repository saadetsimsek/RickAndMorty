//
//  RMLocationDetailViewViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 16/02/2024.
//

import Foundation

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel {

    private let endpointUrl: URL?
    
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])?{
        didSet{
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: RMLocationDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = [] // only read
    

    //MARK: - Init

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        
    }
    
    public func character(at index: Int) -> RMCharacter?{
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    
    //MARK: - Private
    
    private func createCellViewModels(){
        guard let dataTuple = dataTuple else{
            return
        }
        let location = dataTuple.location
        let characters = dataTuple.characters
        
        var creatingString = location.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            creatingString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: creatingString),
            ]),
            .characters(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(characterName: character.name,
                                                              characterStatus: character.status,
                                                              characterImageUrl: URL(string: character.image))
            }))
        ]
    }
    
    ///Fetch backking location model
    public func fetchLocationData(){
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request,
                                 expecting: RMLocation.self) {[weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    //karakter urli elde etme
    private func fetchRelatedCharacters(location: RMLocation) {
        let requests: [RMRequest] = location.residents.compactMap({
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
                location: location,
                characters: characters
            )
        }
    }
}

