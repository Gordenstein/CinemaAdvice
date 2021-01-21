//
//  MoviesListViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit
import Firebase

class MoviesListViewController: UIViewController, MovieFiltersViewControllerDelegate {
  // MARK: Filters View Controller Delegate
  func finishEditingFilters(_ controller: MovieFiltersViewController, newFilters: Filters) {
    navigationController?.popViewController(animated: true)
    filters = newFilters
    applyingFilters()
  }

  @IBOutlet weak var collectionView: UICollectionView!

  var filters = Filters()
  var showResults: [SearchResultFire] = []
  var wholeData: [SearchResultFire] = []
  var haveResults = false
  var hasSearched = false
  let usersReference = Database.database().reference(withPath: Constants.usersPath)

  override func viewDidLoad() {
    super.viewDidLoad()
    cellRegistration()
    setOnlineStatusToDB()
    firstDownloadData()
  }

  func cellRegistration() {
    let loadingCell = UINib(nibName: Constants.loadingCellID, bundle: nil)
    collectionView.register(loadingCell, forCellWithReuseIdentifier: Constants.loadingCellID)
    let nothingFoundCell = UINib(nibName: Constants.nothingFoundCellID, bundle: nil)
    collectionView.register(nothingFoundCell, forCellWithReuseIdentifier: Constants.nothingFoundCellID)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }

  func setOnlineStatusToDB() {
    let userDefaults = UserDefaults.standard
    guard let userID = userDefaults.object(forKey: Constants.userIDKey) as? String,
          let userEmail = userDefaults.object(forKey: Constants.userIDKey) as? String else {
      // No ID or Email
      return
    }
    let currentUserReference = self.usersReference.child(userID)
    currentUserReference.setValue(userEmail)
    currentUserReference.onDisconnectRemoveValue()
  }

  func firstDownloadData() {
    var searchResultReference = Database.database().reference(withPath: Constants.moviesListPath)
    if Constants.loadOneFilmFromDB {
      searchResultReference = searchResultReference.child("100")
      searchResultReference.observe(.value) { (snapshot) in
        var newItems: [SearchResultFire] = []
        let searchItem = SearchResultFire(snapshot: snapshot)
        newItems.append(searchItem)
        self.wholeData = newItems
        self.setSearchResult()
      }
    } else {
      searchResultReference.observe(.value) { (snapshot) in
        var newItems: [SearchResultFire] = []
        for item in snapshot.children {
          let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
          newItems.append(searchItem)
        }
        self.wholeData = newItems
        self.setSearchResult()
      }
    }
  }

  func setSearchResult() {
    showResults = wholeData
    hasSearched = true
    if showResults.count > 0 {
      haveResults = true
    } else {
      haveResults = false
    }
    collectionView.reloadData()
  }

  func applyingFilters() {
    let temporaryFilters = filters
    switch filters.endAge {
      case 0: filters.endAge = 0
      case 1: filters.endAge = 6
      case 2: filters.endAge = 12
      case 3: filters.endAge = 16
      case 4: filters.endAge = 18
      default: filters.endAge = 0
    }
    switch filters.startAge {
      case 0: filters.startAge = 0
      case 1: filters.startAge = 6
      case 2: filters.startAge = 12
      case 3: filters.startAge = 16
      case 4: filters.startAge = 18
      default: filters.startAge = 0
    }
    var usingGenres = false
    for genre in filters.genres {
      if genre.1 {
        usingGenres = true
      }
    }
    if !usingGenres {
      for genre in 0..<filters.genres.count {
        filters.genres[genre].1 = true
      }
    }

    showResults = []
    for film in wholeData {
      var conformityGenres = false
      for genre in film.genres {
        for filtersGenre in filters.genres {
          if filtersGenre.1 {
            if genre == filtersGenre.0 {
              conformityGenres = true
            }
          }
        }
      }
      if conformityGenres {
        if film.year >= filters.startYear, film.year <= filters.endYear,
           film.ageLimit ?? 0 >= filters.startAge, film.ageLimit ?? 0 <= filters.endAge {
          showResults.append(film)
        }
      }
    }
    filters = temporaryFilters
    if showResults.count > 0 {
      haveResults = true
    } else {
      haveResults = false
    }
    collectionView.reloadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.showDetailViewSegueID {
      if hasSearched {
        let movieInfoViewController = segue.destination as! MovieInfoViewController
        let indexPath = sender as! IndexPath
        let searchResult = showResults[indexPath.row]
        movieInfoViewController.searchResult = searchResult
      }
    }
    if segue.identifier == Constants.showFiltersSegueID {
      let movieFiltersViewController = segue.destination as! MovieFiltersViewController
      movieFiltersViewController.filters = filters
      movieFiltersViewController.delegate = self
    }
  }

  // MARK: Private Methods
  private func checkNil(in films: [SearchResultFire]) {
    print("budget \n_________________________________________")
    for item in films {
      if item.budget == nil {
        print(item.key, item.nameRu)
      }
    }
    print("nameEn имя \n_________________________________________")
    for item in films {
      if item.nameEn == nil {
        print(item.key, item.nameRu)
      }
    }
    print("directors \n_________________________________________")
    for item in films {
      if item.directors == nil {
        print(item.key, item.nameRu)
      }
    }
    print("producers \n_________________________________________")
    for item in films {
      if item.producers == nil {
        print(item.key, item.nameRu)
      }
    }
    print("ratingMpaa \n_________________________________________")
    for item in films {
      if item.ratingMpaa == nil {
        print(item.key, item.nameRu)
      }
    }
    print("ageLimit \n_________________________________________")
    for item in films {
      if item.ageLimit == nil {
        print(item.key, item.nameRu)
      }
    }
    print("keywords \n_________________________________________")
    for item in films {
      if item.keywords == nil {
        print(item.key, item.nameRu)
      }
    }
  }

  private func checkDeletedFilms() {
    for film in wholeData {
      var presence = false
      for item in showResults {
        if film.key == item.key {
          presence = true
        }
      }
      if !presence {
        print(film.key, film.nameRu)
      }
    }
  }
}

// MARK: - Search Bar
extension MoviesListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    applyingSearchBar(textForSearch: searchBar.text!)
    print("The search text is: '\(searchBar.text!)'")
  }

  func applyingSearchBar(textForSearch: String) {
    if textForSearch == "" {
      applyingFilters()
    } else {
      applyingFilters()
      let oldResults = showResults
      showResults = []
      for film in oldResults {
        if film.nameRu.contains(textForSearch) || film.nameEn?.contains(textForSearch) ?? false {
          showResults.append(film)
        }
      }
      if showResults.count > 0 {
        haveResults = true
      } else {
        haveResults = false
      }
    }
    collectionView.reloadData()
  }

  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

// MARK: - Collection View Delegates
extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if !hasSearched {
      return 27
    } else if haveResults {
      if showResults.count <= 250 {
        return showResults.count
      } else {
        return 250
      }
    } else {
      return 1
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if !hasSearched {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.loadingCellID, for: indexPath)
      let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else if haveResults {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellID, for: indexPath) as! SearchResultCell
      let searchResult = showResults[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.nothingFoundCellID, for: indexPath)
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if hasSearched && haveResults {
      collectionView.deselectItem(at: indexPath, animated: true)
      performSegue(withIdentifier: Constants.showDetailViewSegueID, sender: indexPath)
    }
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let headerView: UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.collectionViewHeaderID, for: indexPath)
      return headerView
    }
    return UICollectionReusableView()
  }
}
