//
//  RMLocationViewViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 14/02/2024.
//

import Foundation

final class RMLocationViewViewModel {
    
    private var locations: [RMLocation] = []
    
    //location response info
    //will contain next url, if present
    
    private var cellViewModels: [String] = []
    
    init(){
        
    }
    
    public func fetchLocations(){
        RMService.shared.execute(.listLocationRequest, expecting: String.self) { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
