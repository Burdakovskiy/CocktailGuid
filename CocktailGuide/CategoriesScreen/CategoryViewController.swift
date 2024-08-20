//
//  ViewController.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import UIKit

class CategoryViewController: UIViewController {

//MARK: - Properties
    
    private let coctailService = CocktailService()
    private var categories = [Category]()
    private let categoryView = CategoryView()
    
//MARK: - Functions
    
    private func setupNavController() {
        title = "Cocktail Guide"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupDelegates() {
        categoryView.setTableView(delegate: self)
        categoryView.setTableView(dataSource: self)
    }
    
    private func loadCategories() {
        Task {
            do {
                categories = try await coctailService.fetchCategories()
                categoryView.reloadTableView()
            } catch {
                print("Failed to load categories: \(error)")
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view = categoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupNavController()
        loadCategories()
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
