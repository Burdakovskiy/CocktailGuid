//
//  CocktailInfoViewController.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import UIKit

final class CocktailInfoViewController: UIViewController {

//MARK: - Properties
    
    private let cocktailService = CocktailService()
    private let infoView = CocktailInfoView()
    private var cocktailInfo: CocktailDetails?
    var cocktail: Cocktail!
    
//MARK: - Functions
    
    private func setupNavController() {
        title = cocktail.strDrink
        navigationItem.backButtonTitle = "Back"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func loadCocktailInfo() {
        Task {
            do {
                cocktailInfo = try await cocktailService.fetchCocktailDetails(for: cocktail.idDrink)
                infoView.configure(with: cocktailInfo!)
            } catch {
                print("Failed to load cocktailInfo: \(error)")
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view = infoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        loadCocktailInfo()
    }
}
