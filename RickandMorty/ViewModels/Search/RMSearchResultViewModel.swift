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
enum RMSearchResultViewModel{
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
