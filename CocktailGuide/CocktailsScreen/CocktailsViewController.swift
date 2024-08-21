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
    var cocktails = [Cocktail]()
    var category: Category?
    var isSearchResult: Bool = false
    var searchQuery: String?
    var searchController = UISearchController()
    var isOwnSearchControllerActive = true
    
//MARK: - Functions
    
    private func setupNavController() {
        navigationItem.backButtonTitle = "Back"
        title = category?.strCategory ?? "Search Results"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(searchButtonPressed))
    }
    
    private func setupDelegates() {
        cocktailView.setCollectionView(delegate: self)
        cocktailView.setCollectionView(dataSource: self)
    }
    
    private func loadCocktails() {
        Task {
            do {
                if let category {
                    cocktails = try await cocktailService.fetchCocktails(for: category.strCategory )
                }
                cocktailView.reloadCollectionView()
            } catch {
                print("Failed to load categories: \(error)")
            }
        }
    }
    
    @objc private func searchButtonPressed() {
        searchController.isActive.toggle()
        if searchController.isActive {
            searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func loadView() {
        super.loadView()
        view = cocktailView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isSearchResult {
            searchController.isActive = true
            searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupNavController()
        if isSearchResult, let searchQuery {
            searchController.isActive = true
            searchController.searchBar.text = searchQuery
        } else {
            loadCocktails()
        }
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

//MARK: - UISearchResultsUpdating
extension CocktailsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            if !isOwnSearchControllerActive {
                navigationController?.popToRootViewController(animated: true)
            } else {
                loadCocktails()
                cocktailView.reloadCollectionView()
            }
            return
        }
        searchCocktails(query: query)
    }
    
    private func searchCocktails(query: String) {
        Task {
            do {
                cocktails = try await cocktailService.searchCocktails(query: query)
                cocktailView.reloadCollectionView()
            } catch {
                print("Failed to search cocktails: \(error.localizedDescription)")
            }
        }
    }
}
//MARK: - UISearchBarDelegate
extension CocktailsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if isSearchResult {
            cocktails.removeAll()
            navigationController?.popToRootViewController(animated: true)
        } else {
            loadCocktails()
        }
    }
}
