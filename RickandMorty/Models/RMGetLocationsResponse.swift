//
//  RMGetLocationsResponse.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 14/02/2024.
//

import Foundation
struct RMGetAllLocationsResponse: Codable {
    struct Info: Codable{
        let count : Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    let info: Info
    let results: [RMLocation]
}
