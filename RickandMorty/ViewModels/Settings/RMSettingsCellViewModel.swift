//
//  RMSettingsCellViewModel.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 01/02/2024.
//

import Foundation
import UIKit

struct RMSettingsCellViewModel: Identifiable, Hashable {
    let id = UUID()
    
    private let type: RMSettingsOption
    
    //MARK: - Init
    init(type: RMSettingsOption){
        self.type = type
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
