# CocktailGuide

CocktailGuide is an iOS application for exploring and managing cocktail recipes. Users can browse categories, search for cocktails, and view detailed information about each cocktail.

## Technologies & Frameworks

- **Swift**: The primary programming language used for developing the application.
- **UIKit**: Framework for building the user interface.
- **Kingfisher**: A powerful image downloading and caching library used to handle cocktail images.
- **Swift Concurrency (async/await)**: For performing asynchronous operations.
- **MVC**

## Key Components

### Model

- **CocktailDataModel.swift**: Contains data models for cocktails, categories, and their details, using Swift's `Codable` for parsing JSON responses from the API.

### Service

- **CocktailService.swift**: Handles network requests to the [TheCocktailDB API](https://www.thecocktaildb.com/api.php) to fetch categories, cocktails, and cocktail details. Uses async/await for asynchronous operations.

### Views

- **CategoryView**: Displays a list of cocktail categories using a `UITableView`.
- **CocktailView**: Shows a collection of cocktails within a selected category or search result using a `UICollectionView`.
- **CocktailInfoView**: Provides detailed information about a selected cocktail.

### ViewControllers

- **CategoryViewController**: Manages the category selection and integrates search functionality with `UISearchController`.
- **CocktailsViewController**: Displays cocktails based on selected category or search query and handles user interactions.
- **CocktailInfoViewController**: Shows detailed information about a selected cocktail.
