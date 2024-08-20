//
//  CocktailDataModel.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import Foundation

struct CategoryResponse: Decodable {
    let drinks: [Category]
}

struct Category: Decodable {
    let strCategory: String
}

struct CocktailsResponse: Decodable {
    let drinks: [Cocktail]
}

struct Cocktail: Decodable {
    let strDrink: String
    let strDrinkThumb: String?
    let idDrink: String
}

struct CocktailDetailResponse: Decodable {
    let drinks: [CocktailDetails]
}

struct CocktailDetails: Decodable {
    let strDrink: String
    let strInstructions: String
    let strDrinkThumb: String?
    let ingredients: [String]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.strDrink = try container.decode(String.self, forKey: .strDrink)
        self.strInstructions = try container.decode(String.self, forKey: .strInstructions)
        self.strDrinkThumb = try container.decode(String.self, forKey: .strDrinkThumb)
        
        var ingredients = [String]()
        for i in 1...15 {
            if let key = CodingKeys(stringValue: "strIngredient\(i)"),
               let ingredient = try container.decodeIfPresent(String.self, forKey: key) {
                ingredients.append(ingredient)
            }
        }
        self.ingredients = ingredients
    }
    
    enum CodingKeys: String, CodingKey {
        case strDrink, strInstructions, strDrinkThumb
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
    }
}

