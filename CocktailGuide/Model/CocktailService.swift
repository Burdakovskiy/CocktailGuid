//
//  CocktailService.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import Foundation

final class CocktailService {
    
    //MARK: - Properties
    
    //Base API URL
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    //MARK: - Functions
    
    //Getting and decode categoriesResponse and getting Categories from categoriesResponse
    func fetchCategories() async throws -> [Category] {
        let url = URL(string: "\(baseURL)list.php?c=list")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let categoriesResponse = try JSONDecoder().decode(CategoryResponse.self, from: data)
        return categoriesResponse.drinks
    }
    
    //Getting and decode cocktailsResponse based on chosen category and getting Cocktail(s) from cocktailsResponse
    func fetchCocktails(for category: String) async throws -> [Cocktail] {
        let url = URL(string: "\(baseURL)filter.php?c=\(category)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let cocktailsResponse = try JSONDecoder().decode(CocktailsResponse.self, from: data)
        return cocktailsResponse.drinks
    }
    
    //Getting and decode detailsResponse based on chosen cocktail id and getting cocktail detail info from detailsResponse, if info is absent throws a 404 error code
    func fetchCocktailDetails(for id: String) async throws -> CocktailDetails {
        let url = URL(string: "\(baseURL)lookup.php?i=\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let detailsResponse = try JSONDecoder().decode(CocktailDetailResponse.self, from: data)
        guard let cocktail = detailsResponse.drinks.first else {
            throw NSError(domain: "Coctail not found", code: 404)
        }
        return cocktail
    }
    
}
