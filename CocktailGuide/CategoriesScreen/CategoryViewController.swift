//
//  ViewController.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import UIKit

class CategoryViewController: UIViewController {

//MARK: - Properties
    
    private let cocktailService = CocktailService()
    private let categoryView = CategoryView()
    private var categories = [Category]()
    
    //Search
    private var filteredCocktails = [Cocktail]()
    private var searchController = UISearchController()
    private var isSearching = false
    private var searchTask: DispatchWorkItem?
    
//MARK: - Functions
    
    private func setupNavController() {
        title = "Cocktail Guide"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Search
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(searchButtonPressed))
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search cocktails"
        searchController.delegate = self
        searchController.isActive = false
        definesPresentationContext = true
    }
    
    private func setupDelegates() {
        categoryView.setTableView(delegate: self)
        categoryView.setTableView(dataSource: self)
    }
    
    private func loadCategories() {
        Task {
            do {
                categories = try await cocktailService.fetchCategories()
                categoryView.reloadTableView()
            } catch {
                print("Failed to load categories: \(error)")
            }
        }
    }
    
    private func searchCocktails(query: String) {
        Task {
            do {
                filteredCocktails = try await cocktailService.searchCocktails(query: query)
                if !filteredCocktails.isEmpty {
                    isSearching = true
                    let cocktailsVC = CocktailsViewController()
                    cocktailsVC.cocktails = filteredCocktails
                    cocktailsVC.isSearchResult = true
                    cocktailsVC.searchQuery = query
                    cocktailsVC.searchController = searchController
                    cocktailsVC.isOwnSearchControllerActive = false
                    navigationController?.pushViewController(cocktailsVC, animated: true)
                } else {
                    isSearching = false
                }
            } catch {
                print("Failed to search cocktails: \(error.localizedDescription)")
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
        view = categoryView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavController()
        loadCategories()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
}

//MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chosenCategory = categories[indexPath.row]
        let coctailsVC = CocktailsViewController()
        coctailsVC.category = chosenCategory
        navigationController?.pushViewController(coctailsVC, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.cellId,
                                                 for: indexPath) as! CategoryTableViewCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }
}

//MARK: - UISearchResultsUpdating
extension CategoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            isSearching = false
            categoryView.reloadTableView()
            navigationController?.popToViewController(self, animated: true)
            return
        }
        searchTask?.cancel()
        
        if isSearching && navigationController?.topViewController is CocktailsViewController {
            return
        }
        
        let task = DispatchWorkItem {[weak self] in
            guard let self else { return }
            searchCocktails(query: query)
        }
        
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
    }
}

//MARK: - UISearchControllerDelegate
extension CategoryViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        isSearching = false
        categoryView.reloadTableView()
    }
}
