//
//  MainView.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import UIKit

final class CategoryView: UIView {
    
//MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - Properties
    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.bounces = false
        tableView.register(CategoryTableViewCell.self,
                           forCellReuseIdentifier: CategoryTableViewCell.cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
//MARK: - Functions
    
    private func setupViews() {
        addSubview(categoryTableView)
    }
    
    func setTableView(delegate: UITableViewDelegate) {
        categoryTableView.delegate = delegate
    }
    
    func setTableView(dataSource: UITableViewDataSource) {
        categoryTableView.dataSource = dataSource
    }
    
    func reloadTableView() {
        categoryTableView.reloadData()
    }
}

//MARK: - setConstraints
private extension CategoryView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            categoryTableView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            categoryTableView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
