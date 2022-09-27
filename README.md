# Anthony-Movie-App
Demonstrate the use of MVVM-C + RxSwift with SOLID in mind

# Technologies
TheMovieApp use the following architecture and technologies
1. [MVVM-C](https://www.marcosantadev.com/mvvmc-with-swift/): Model - View - ViewModel - Coordinator
2. [RxSwift](https://github.com/ReactiveX/RxSwift): Reactive Swift
3. [Coordinator pattern](https://github.com/quickbirdstudios/XCoordinator): Navigation Machanism 
4. [DifferenceKit](https://github.com/ra1028/DifferenceKit): Data change detection for better performance
5. [Moya/Reactive](https://github.com/Moya/Moya): Build on top of Alamofire, easy to scale up app
6. [Kingfisher](https://github.com/onevcat/Kingfisher): Make easy to work with Image
7. [Resolver](https://github.com/hmlongco/Resolver): Dependecy Injection framework to connect and locate independent business logic

# Objective:

Create a master-detail application that contains at least one dependency. This application should display a list of items obtained from an iTunes Search API and show a detailed view of each item. The URL you must obtain your data from is as follows:

https://itunes.apple.com/search?term=star&country=au&media=movie&;all

(iTunes Web Service Documentation: https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/#searching). If the link is inaccessible, please click here.

## Feature #1
1. As a user, I can add a favorite movie
2. should be able to favorite a movie on the list screen
3. should be able to favorite a movie on the detail screen
4. should be able to favorite a movie on detail screen, go back, and should be displayed as a favorite on the list screen
5. should show favorites offline

## Feature #2
1. As a user, I can search a movie
2. when user type, should trigger search after typing
3. should show an empty screen when a search is empty

## General:

### Show the following details from the API:
1. Track Name
2. Artwork 
3. Price
4. Genre
5. In addition, the detail view should show a Long Description for the given item
6. Each row should have a placeholder image if for some reason the URL is unable to be loaded. Images must not be duplicated when scrolling.

## Persistence:
1. A date when the user previously visited, shown in the list header
2. Save the last screen that the user was on. When the app restores, it should present the user with that screen.
