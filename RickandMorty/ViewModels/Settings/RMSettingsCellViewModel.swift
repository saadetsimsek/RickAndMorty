//
//  RMSettingsCellViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 01/02/2024.
//

import Foundation
import UIKit

struct RMSettingsCellViewModel: Identifiable {
    let id = UUID()
    
    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void
    
    //MARK: - Init
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void){
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    //MARK: - Public
    public var title: String{
        return type.displayTitle
    }
    
    public var image: UIImage?{
        return type.iconImage
    }
    
    public var iconContainerColor: UIColor{
        return type.iconContainerColor
    }
  
   
}
