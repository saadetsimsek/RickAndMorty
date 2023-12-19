//
//  RMCharacterStatus.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 15/12/2023.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "unknown"
        }
    }
}
