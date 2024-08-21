//
//  CocktailInfoView.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import UIKit

final class CocktailInfoView: UIView {
    
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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "Ingredients:\n"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//MARK: - Functions
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(ingredientsLabel)
        scrollView.addSubview(descriptionLabel)
    }
    
    func configure(with cocktail: CocktailDetails) {
        for ingredient in cocktail.ingredients {
            ingredientsLabel.text! += "- \(ingredient)\n"
            if cocktail.ingredients.isEmpty {
                ingredientsLabel.text = ""
            }
        }
        
        if !cocktail.strInstructions.isEmpty {
            descriptionLabel.text = "Instruction:\n\(cocktail.strInstructions)"
        } else {
            descriptionLabel.text = "Doesn`t have instruction"
            descriptionLabel.textAlignment = .center
        }
        
        if let urlString = cocktail.strDrinkThumb, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}

//MARK: - setConstraints
private extension CocktailInfoView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            ingredientsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            ingredientsLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            ingredientsLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            ingredientsLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            descriptionLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 16),
            descriptionLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
}
