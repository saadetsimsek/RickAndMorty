//
//  RMSettingsViewController.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 15/12/2023.
//
import SafariServices
import SwiftUI
import UIKit

///Constroller to show various app options and settings
final class RMSettingsViewController: UIViewController {
    
    private var settingsSwiftUIController: UIHostingController<RMSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
        
    }
    
    private func addSwiftUIController(){
        let settingsSwiftUIController = UIHostingController(rootView:  RMSettingsView(viewModel: RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0, onTapHandler: { [weak self] option in
                self?.handleTap(option: option)
            })
    }))))
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        self.settingsSwiftUIController = settingsSwiftUIController
    }
    
    //ana kodun (main thread) çalışmasını sağlar. Eğer kod, ana iş parçacığında çalışmıyorsa (yani, mevcut iş parçacığı ana iş parçacığı değilse), fonksiyonun geri kalanını atlar ve işlemi sonlandırır.
    private func handleTap(option: RMSettingsOption){
        guard Thread.current.isMainThread else {
            return
        }
        if let url = option.targetUrl {
            //open website
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
        else if option == .rateApp{
            //show rating prompt
        }
    }
}
