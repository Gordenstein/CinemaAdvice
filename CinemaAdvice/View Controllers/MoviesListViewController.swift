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

  // MARK: Start
  struct CollectionViewCellIdentifiers {
    static let nothingFoundCellIdentifier = "NothingFoundCell"
    static let loadingCellIdentifier = "LoadingCell"
    static let collectionViewCellIdentifier = "CollectionViewCell"
  }

  @IBOutlet weak var collectionView: UICollectionView!

  let testShot = false

  var filters = Filters()
  var showResults: [SearchResultFire] = []
  var wholeData: [SearchResultFire] = []
  var haveResults = false
  var hasSearched = false
  var user: User!
  let usersReference = Database.database().reference(withPath: "online")

  override func viewDidLoad() {
    super.viewDidLoad()
    cellRegistration()
    addStateDidChangeListener()
    firstDownloadData()
  }

  func cellRegistration() {
    let loadingCell = UINib(nibName: CollectionViewCellIdentifiers.loadingCellIdentifier, bundle: nil)
    collectionView.register(loadingCell, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.loadingCellIdentifier)
    let nothingFoundCell = UINib(nibName: CollectionViewCellIdentifiers.nothingFoundCellIdentifier, bundle: nil)
    collectionView.register(nothingFoundCell, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.nothingFoundCellIdentifier)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }

  func addStateDidChangeListener() {
    Auth.auth().addStateDidChangeListener { _, user in
      if let user = user {
        self.user = User(uid: user.uid, email: user.email!)
        let currentUserReference = self.usersReference.child(self.user.uid)
        currentUserReference.setValue(self.user.email)
        currentUserReference.onDisconnectRemoveValue()
      }
    }
  }

  func firstDownloadData() {
    var searchResultReference = Database.database().reference(withPath: "films")
    if testShot {
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
    if segue.identifier == "ShowDetailView" {
      if hasSearched {
        let movieInfoViewController = segue.destination as! MovieInfoViewController
        let indexPath = sender as! IndexPath
        let searchResult = showResults[indexPath.row]
        movieInfoViewController.searchResult = searchResult
      }
    }
    if segue.identifier == "ShowFilters" {
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
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.loadingCellIdentifier, for: indexPath)
      let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else if haveResults {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.collectionViewCellIdentifier, for: indexPath) as! SearchResultCell
      let searchResult = showResults[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.nothingFoundCellIdentifier, for: indexPath)
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if hasSearched && haveResults {
      collectionView.deselectItem(at: indexPath, animated: true)
      performSegue(withIdentifier: "ShowDetailView", sender: indexPath)
    }
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let headerView: UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)
      return headerView
    }
    return UICollectionReusableView()
  }
}
