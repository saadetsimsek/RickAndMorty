//
//  RMCharacterInfoViewCellViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 19/12/2023.
//

import Foundation
import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    
    private let type: Typee
    
    private let value: String
    
    static let dateFormatter: DateFormatter = {
        //Format
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    
    public var title: String {
        type.displayTitle
    }
    
    public var displayValue: String{
    
        if value.isEmpty {return "None"}
        
        //2022-12-25T16:35: 06+0000
        if let date = Self.dateFormatter.date(from: value),
           type == .created {
            return Self.shortDateFormatter.string(from: date)
        }
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor? {
        return type.tintColor
    }
    
    enum Typee: String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodeCount
        
        var tintColor: UIColor? {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemRed
            case .type:
                return .systemMint
            case .species:
                return .systemOrange
            case .origin:
                return .systemYellow
            case .location:
                return .systemPurple
            case .created:
                return .systemYellow
            case .episodeCount:
                return .systemGreen
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        
        var displayTitle: String {
            switch self {
            case .status,
                 .gender,
                 .type,
                 .species,
                 .origin,
                 .created,
                 .location:
                return rawValue.uppercased()
            case .episodeCount:
                return "episode count"
            }
        }
    }
   
    init( type: Typee,
          value: String){
        self.value = value
        self.type = type
        //dflmgvçfmgçlerfg
        
        
    }
}
