//
//  RMEndpoint.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 15/12/2023.
//

import Foundation

///Represent unique API endpoint
@frozen enum RMEndpoint: String {
    case character // "character"
    case location
    case episode
}
