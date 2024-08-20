//
//  UITableViewCell+Extension.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import UIKit

extension UITableViewCell {
    static var cellId: String {
        self.description()
    }
}
