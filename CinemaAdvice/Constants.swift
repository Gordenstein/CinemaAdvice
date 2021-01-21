//
//  Constants.swift
//  CinemaAdvice
//
//  Created by Eugene Gordenstein on 1/20/21.
//  Copyright © 2021 Eugene Gordenstein. All rights reserved.
//

import Foundation

struct Constants {
  // App Setings
  static let checkEmailVerification = false
  static let loadOneFilmFromDB = false
  
  // MARK: Identifiers
  // LoginViewController
  static let loginToListSegueID = "LoginToList"
  
  // MoviesListViewController
  static let nothingFoundCellID = "NothingFoundCell"
  static let loadingCellID = "LoadingCell"
  static let collectionViewCellID = "CollectionViewCell"
  static let collectionViewHeaderID = "CollectionViewHeader"
  
  static let showDetailViewSegueID = "ShowDetailView"
  static let showFiltersSegueID = "ShowFilters"
  
  // MovieFiltersViewController
  static let showGenresSegueID = "ShowGenres"
  
  // MovieGenresViewController
  static let genreItemCellID = "GenreItem"
  
  // MainAlgorithmViewController
  static let showResultCellID = "ShowResult"
  
  // FavoriteMoviesViewController
  static let libraryCellID = "LibraryCell"
  
  // Search result
  static let nameRu = "nameRu"
  static let nameEn = "nameEn"
  static let imageUrl = "imageUrl"
  static let year = "year"
  static let countries = "countries"
  static let tagline = "tagline"
  static let directors = "directors"
  static let producers = "producers"
  static let genres = "genres"
  static let budget = "budget"
  static let ageLimit = "ageLimit"
  static let ratingKinopoisk = "ratingKinopoisk"
  static let ratingMpaa = "ratingMpaa"
  static let duration = "duration"
  static let actors = "actors"
  static let description = "description"
  static let opinion = "opinion"
  static let keywords = "keywords"
  
  // UserDefaults
  static let userIDKey = "userUID"
  static let userEmailKey = "userEmail"
  static let userFavoriteFilmsPathKey = "userFavoriteFilmsPath"
  
  // Firebase paths
  static let usersPath = "online"
  static let usersPathPrefix = "online/"
  static let moviesListPath = "films"
  static let usersFavoriteFilmsPath = "libraries"
  static let userFavoriteFilmsPathPrefix = "library-"
}
