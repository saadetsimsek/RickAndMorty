//
//  RMLocationViewViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 14/02/2024.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    private var locations: [RMLocation] = []
    
    //location response info
    //will contain next url, if present
    
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    private var cellViewModels: [String] = []
    
    init(){
        
    }
    
    public func fetchLocations(){
        RMService.shared.execute(.listLocationRequest, expecting: RMGetAllLocationsResponse.self) {[weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                break
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
