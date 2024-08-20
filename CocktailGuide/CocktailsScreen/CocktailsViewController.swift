//
//  CoctailsViewController.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import Foundation

import UIKit

class CocktailsViewController: UIViewController {

//MARK: - Properties
    
    private let cocktailService = CocktailService()
    private let cocktailView = CocktailView()
    private var cocktails = [Cocktail]()
    var category: Category!
    
//MARK: - Functions
    
    private func setupNavController() {
        title = category.strCategory
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupDelegates() {
        cocktailView.setCollectionView(delegate: self)
        cocktailView.setCollectionView(dataSource: self)
    }
    
    private func loadCategories() {
        Task {
            do {
                cocktails = try await cocktailService.fetchCocktails(for: category.strCategory )
                cocktailView.reloadCollectionView()
            } catch {
                print("Failed to load categories: \(error)")
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view = cocktailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupNavController()
        loadCategories()
    }
}

//MARK: - UICollectionViewDelegate
extension CocktailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let chosenCocktail = cocktails[indexPath.row]
        let infoVC = CocktailInfoViewController()
        infoVC.cocktail = chosenCocktail
        navigationController?.pushViewController(infoVC, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension CocktailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cocktails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoctailCollectionViewCell.cellId,
                                                      for: indexPath) as! CoctailCollectionViewCell
        cell.configure(with: cocktails[indexPath.row])
        return cell
    }
}
