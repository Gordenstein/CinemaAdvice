//
//  MoviesListViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordenstein. All rights reserved.
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
  var showResults: [Movie] = []
  var wholeData: [Movie] = []
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
        var newItems: [Movie] = []
        let searchItem = Movie(snapshot: snapshot)
        newItems.append(searchItem)
        self.wholeData = newItems
        self.setSearchResult()
      }
    } else {
      searchResultReference.observe(.value) { (snapshot) in
        var newItems: [Movie] = []
        for item in snapshot.children {
          if let snapshot = item as? DataSnapshot {
            let searchItem = Movie(snapshot: snapshot)
            newItems.append(searchItem)
          }
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

  // swiftlint:disable:next cyclomatic_complexity
  func applyingFilters() {
    var startAge = 0
    var endAge = 0
    switch filters.startAge {
    case 0: startAge = 0
    case 1: startAge = 6
    case 2: startAge = 12
    case 3: startAge = 16
    case 4: startAge = 18
    default: startAge = 0
    }
    switch filters.endAge {
    case 0: endAge = 0
    case 1: endAge = 6
    case 2: endAge = 12
    case 3: endAge = 16
    case 4: endAge = 18
    default: endAge = 0
    }
    var allowedGenres = Set<String>()
    let filterGenres = filters.genres
    for genreKey in filters.genres.keys where filterGenres[genreKey] ?? false {
      allowedGenres.insert(genreKey)
    }

    showResults = []
    for film in wholeData {
      if !allowedGenres.isEmpty {
        var fitIn = false
        genreLoop: for filmGenre in film.genres {
          if allowedGenres.contains(filmGenre) {
            fitIn = true
            break genreLoop
          }
        }
        if !fitIn {
          continue
        }
      }

      if film.year >= filters.startYear,
         film.year <= filters.endYear,
         film.ageLimit ?? 0 >= startAge,
         film.ageLimit ?? 0 <= endAge {
        showResults.append(film)
      }
    }

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
      if hasSearched,
         let movieInfoViewController = segue.destination as? MovieInfoViewController,
         let indexPath = sender as? IndexPath {

        let searchResult = showResults[indexPath.row]
        movieInfoViewController.searchResult = searchResult
      }
    }
    if segue.identifier == Constants.showFiltersSegueID,
       let movieFiltersViewController = segue.destination as? MovieFiltersViewController {
      movieFiltersViewController.filters = filters
      movieFiltersViewController.delegate = self
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
      if let spinner = cell.viewWithTag(101) as? UIActivityIndicatorView {
        spinner.startAnimating()
      }
      return cell
    } else if haveResults,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellID,
                                                            for: indexPath) as? SearchResultCell {
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

  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: Constants.collectionViewHeaderID, for: indexPath)
      return headerView
    }
    return UICollectionReusableView()
  }
}
