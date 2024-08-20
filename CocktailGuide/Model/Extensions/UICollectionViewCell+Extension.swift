//
//  UICollectionViewCell+Extension.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import UIKit

extension UICollectionViewCell {
    static var cellId: String {
        self.description()
    }
}
