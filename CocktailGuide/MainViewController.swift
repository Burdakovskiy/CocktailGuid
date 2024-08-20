//
//  ViewController.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import UIKit

class MainViewController: UIViewController {

//MARK: - Properties
    private let mainView = MainView()
    
//MARK: - Functions
    
    private func setupNavController() {
        title = "Cocktail Guide"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

