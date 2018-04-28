//
//  FirstViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
  struct CollectionViewCellIdentifiers {
    static let nothingFoundCell = "NothingFoundCell"
    static let loadingCell = "LoadingCell"
  }

  @IBOutlet weak var collectionView: UICollectionView!
  
  private let search = Search()
  var libraryItems = [SearchResult]()
  var downloadTask: URLSessionDownloadTask?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    var cellNib = UINib(nibName: CollectionViewCellIdentifiers.loadingCell, bundle: nil)
    collectionView.register(cellNib, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.loadingCell)
    cellNib = UINib(nibName: CollectionViewCellIdentifiers.nothingFoundCell, bundle: nil)
    collectionView.register(cellNib, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.nothingFoundCell)
    
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    welcomingSearch()
    if let results = loadResults() {
      libraryItems = results
    }
//    searchBar.becomeFirstResponder()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    if segue.identifier == "ShowDetailView"{
      if case .results(let list) = search.state {
        let detailViewController = segue.destination as! DetailViewController
        let indexPath = sender as! IndexPath
        let searchResult = list[indexPath.row]
        detailViewController.searchResult = searchResult
      }
    }
  }
  
  // MARK: Private Methods
  func showNetworkError() {
    let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store." + "Please try again.", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  private func welcomingSearch () {
    let searchText = "Marvel"
    search.performSearch(for: searchText,
                         completion: {success in
                          if !success {
                            self.showNetworkError()
                          }
                          self.collectionView.reloadData()
    })
    collectionView.reloadData()
  }
}


// MARK:- Search Bar
extension FirstViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("The search text is: '\(searchBar.text!)'")
    performSearch(searchBar: searchBar)
  }
  
  func performSearch(searchBar: UISearchBar) {
    search.performSearch(for: searchBar.text!,
                         completion: {success in
                          if !success {
                            self.showNetworkError()
                          }
                          self.collectionView.reloadData()
    })
    collectionView.reloadData()
    searchBar.resignFirstResponder()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}


// MARK:- Collection View Delegate
extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch search.state {
    case .notSearchedYet:
      return 0
    case .loading:
      return 9
    case .noResults:
      return 1
    case .results(let list):
      return list.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch search.state {
    case .notSearchedYet:
      fatalError("Should never get here")
    case .loading:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.loadingCell, for: indexPath)
      let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    case .noResults:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.nothingFoundCell, for: indexPath)
      return cell
    case .results(let list):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! SearchResultCell
      let searchResult = list[indexPath.row]
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




