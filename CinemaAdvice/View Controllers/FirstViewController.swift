//
//  FirstViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController, FiltersViewControllerDelegate {
  
  func finishEditingFilters(_ controller: FiltersViewController, newFilters: Filters) {
    filters = newFilters
  }
  
  
  struct CollectionViewCellIdentifiers {
    static let nothingFoundCell = "NothingFoundCell"
    static let loadingCell = "LoadingCell"
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  //  private let search = Search()
  //  var libraryItems = [SearchResult]()
  
  var filters = Filters()
  var searchResultFire: [SearchResultFire] = []
  var temporaryFlag = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var cellNib = UINib(nibName: CollectionViewCellIdentifiers.loadingCell, bundle: nil)
    collectionView.register(cellNib, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.loadingCell)
    cellNib = UINib(nibName: CollectionViewCellIdentifiers.nothingFoundCell, bundle: nil)
    collectionView.register(cellNib, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.nothingFoundCell)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    //    welcomingSearch()
    //    if let results = loadResults() {
    //      libraryItems = results
    //    }
    
    let searchResultReference = Database.database().reference(withPath: "films")
    let rootReference = Database.database().reference()
    
    
//    searchResultReference.observe(.value) { (snapshot) in
//      print(snapshot)
//    }
    
    searchResultReference.observe(.value) { (snapshot) in
      var newItems: [SearchResultFire] = []
      for item in snapshot.children {
        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
        newItems.append(searchItem)
      }
      self.searchResultFire = newItems
      self.temporaryFlag = false
      self.collectionView.reloadData()
//      self.checkNil()
    }
  
  }
  

  
  func checkNil() {
    print("budget \n_________________________________________")
    for item in searchResultFire {
      if item.budget == nil {
        print(item.key, item.nameRu)
      }
    }
    print("nameEn имя \n_________________________________________")
    for item in searchResultFire {
      if item.nameEn == nil {
        print(item.key, item.nameRu)
      }
    }
    print("directors \n_________________________________________")
    for item in searchResultFire {
      if item.directors == nil {
        print(item.key, item.nameRu)
      }
    }
    print("producers \n_________________________________________")
    for item in searchResultFire {
      if item.producers == nil {
        print(item.key, item.nameRu)
      }
    }
    print("ratingMpaa \n_________________________________________")
    for item in searchResultFire {
      if item.ratingMpaa == nil {
        print(item.key, item.nameRu)
      }
    }
    print("ageLimit \n_________________________________________")
    for item in searchResultFire {
      if item.ageLimit == nil {
        print(item.key, item.nameRu)
      }
    }
    print("keywords \n_________________________________________")
    for item in searchResultFire {
      if item.keywords == nil {
        print(item.key, item.nameRu)
      }
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
    if segue.identifier == "ShowDetailView" {
      if !temporaryFlag {
        let detailViewController = segue.destination as! DetailViewController
        let indexPath = sender as! IndexPath
        let searchResult = searchResultFire[indexPath.row]
        detailViewController.searchResult = searchResult
      }
    }
    if segue.identifier == "ShowFilters" {
      let filtersViewController = segue.destination as! FiltersViewController
      filtersViewController.filters = filters
      filtersViewController.delegate = self
    }
    
  }
  
  // MARK: Private Methods
  //  func showNetworkError() {
  //    let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store." + "Please try again.", preferredStyle: .alert)
  //    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
  //    alert.addAction(action)
  //    present(alert, animated: true, completion: nil)
  //  }
  //
  //  private func welcomingSearch () {
  //    let searchText = "Marvel"
  //    search.performSearch(for: searchText,
  //                         completion: {success in
  //                          if !success {
  //                            self.showNetworkError()
  //                          }
  //                          self.collectionView.reloadData()
  //    })
  //    collectionView.reloadData()
  //  }
}


// MARK:- Search Bar
extension FirstViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("The search text is: '\(searchBar.text!)'")
    //    performSearch(searchBar: searchBar)
  }
  
  //  func performSearch(searchBar: UISearchBar) {
  //    search.performSearch(for: searchBar.text!,
  //                         completion: {success in
  //                          if !success {
  //                            self.showNetworkError()
  //                          }
  //                          self.collectionView.reloadData()
  //    })
  //    collectionView.reloadData()
  //    searchBar.resignFirstResponder()
  //  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}


// MARK:- Collection View Delegate
extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //    switch search.state {
    //    case .notSearchedYet:
    //      return 0
    //    case .loading:
    //      return 9
    //    case .noResults:
    //      return 1
    //    case .results(let list):
    //      return list.count
    //    }
    if temporaryFlag {
      return 1
    } else {
      return searchResultFire.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //    switch search.state {
    //    case .notSearchedYet:
    //      fatalError("Should never get here")
    //    case .loading:
    //      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.loadingCell, for: indexPath)
    //      let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
    //      spinner.startAnimating()
    //      return cell
    //    case .noResults:
    //      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.nothingFoundCell, for: indexPath)
    //      return cell
    //    case .results(let list):
    //      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! SearchResultCell
    //      let searchResult = list[indexPath.row]
    //      cell.configure(for: searchResult)
    //      return cell
    //    }
    
    if temporaryFlag {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.loadingCell, for: indexPath)
      let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! SearchResultCell
      let searchResult = searchResultFire[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    performSegue(withIdentifier: "ShowDetailView", sender: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if (kind == UICollectionElementKindSectionHeader) {
      let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)
      return headerView
    }
    return UICollectionReusableView()
  }
}




