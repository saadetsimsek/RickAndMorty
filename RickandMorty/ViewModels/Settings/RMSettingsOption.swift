//
//  RMSettingsOption.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 01/02/2024.
//

import Foundation
import UIKit

enum RMSettingsOption: CaseIterable{
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var displayTitle: String{
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Referance"
        case .viewSeries:
            return "View Video Series"
        case .viewCode:
            return "View App Code"
        }
    }
    
    var iconContainerColor: UIColor{
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemRed
        case .terms:
            return .systemPink
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemGreen
        case .viewSeries:
            return .systemMint
        case .viewCode:
            return .systemPurple
        }
    }
    
    var iconImage: UIImage?{
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "lick.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
}
