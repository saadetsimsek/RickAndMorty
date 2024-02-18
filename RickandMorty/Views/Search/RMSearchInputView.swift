//
//  RMSearchInputView.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 16/02/2024.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject{
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
}

final class RMSearchInputView: UIView {
    
    weak var delegate: RMSearchInputViewDelegate?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else{
                return
            }
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(searchBar)
        addConstraits()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    
    private func addConstraits(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func createOptionStackView() -> UIStackView{
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubviews(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        return stackView
    }
    
    private func createOptionSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption]){
        
        let stackView =  createOptionStackView()
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with: option, tag: x)
            stackView.addArrangedSubview(button)
            //print(option.rawValue)
        }
    }
    
    private func createButton(with option: RMSearchInputViewViewModel.DynamicOption, tag: Int)-> UIButton{
        
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: option.rawValue,
                                                     attributes: [.font: UIFont.systemFont(ofSize: 18,
                                                                                           weight: .medium),
                                                        .foregroundColor: UIColor.label]), for: .normal)
    //    button.setTitle(option.rawValue, for: .normal)
     //   button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 6
        return button
    }
    
    @objc private func didTapButton(_ sender: UIButton){
        guard let options = viewModel?.options else {
            return
        }
        let tag = sender.tag
        let selected = options[tag]
        
        delegate?.rmSearchInputView(self, didSelectOption: selected)
        print("Did tap \(selected.rawValue)")
    }
    
    public func configure(with viewModel: RMSearchInputViewViewModel){
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
    public func presentKeyboard(){
        searchBar.becomeFirstResponder()
    }
    
}
