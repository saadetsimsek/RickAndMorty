//
//  RMSearchInputViewViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 16/02/2024.
//

import Foundation

final class RMSearchInputViewViewModel{
    
    private let type: RMSearchViewController.Config.Typee
    
    enum DynamicOption: String{
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var choices: [String]{
            switch self {
            case .status:
                return ["alive", "dead", "unknown"]
            case .gender:
                return ["male", "female", "genderless", "unknown"]
            case .locationType:
                return ["cluster", "planet", "microverse"]
            }
        }
    }
    
    init(type: RMSearchViewController.Config.Typee){
        self.type = type
    }
    
    //MARK: - Public
    
    public var hasDynamicOptions: Bool {
        switch self.type {
        case .character:
            return true
        case .episode:
            return false
        case .location:
            return true
        }
    }
    
    public var options: [DynamicOption]{
        switch self.type {
        case .character:
            return [.status, .gender]
        case .episode:
            return []
        case .location:
            return [.locationType]
        }
    }
    
    public var searchPlaceholderText: String{
        switch self.type {
        case .character:
            return "Character Name"
        case .episode:
            return "Episode Name"
        case .location:
            return "Location Name"
        }
    }
}
