//
//  Extenisions.swift
//  RickandMorty
//
//  Created by Saadet Şimşek on 16/12/2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
