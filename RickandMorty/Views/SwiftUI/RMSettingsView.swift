//
//  RMSettingsView.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 13/02/2024.
//

import SwiftUI

struct RMSettingsView: View {
    
    let viewModel: RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        //list viewde zaten scroll özelliği var
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.red)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                Spacer() // SwiftUI view'i ve bu düzendeki diğer öğeler arasında boşluk bırakmak için kullanılır.
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
        
    }
}

#Preview {
    RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
        return RMSettingsCellViewModel(type: $0){ option in
            
        }
    })))
}

/*
 ScrollView(.vertical){
 ForEach(viewModel.cellViewModels) { viewModel in
 
 Text(viewModel.title)
 }
 */
