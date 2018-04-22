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
    static let searchResultCell = "CollectionViewCell"
    static let nothingFoundCell = "NothingFoundCell"
    static let loadingCell = "LoadingCell"
  }

  @IBOutlet weak var collectionView: UICollectionView!
  
  
  var searchResults = [SearchResult]()
  var libraryItems = [SearchResult]()
  var hasSearched = false
  var isLoading = false
  var dataTask: URLSessionDataTask?
  var downloadTask: URLSessionDownloadTask?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    var cellNib = UINib(nibName: CollectionViewCellIdentifiers.loadingCell, bundle: nil)
    collectionView.register(cellNib, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.loadingCell)
    cellNib = UINib(nibName: CollectionViewCellIdentifiers.nothingFoundCell, bundle: nil)
    collectionView.register(cellNib, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.nothingFoundCell)
    
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    testSearch()
    loadResults()
//    searchBar.becomeFirstResponder()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    if segue.identifier == "ShowDetailView" {
      let detailViewController = segue.destination
        as! DetailViewController
      let indexPath = sender as! IndexPath
      let searchResult = searchResults[indexPath.row]
      detailViewController.searchResult = searchResult
    }
  }
  
  // MARK: Private Methods
  func iTunesURL(searchText: String) -> URL {
    
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    
    let urlString = "https://itunes.apple.com/search?" + "term=\(encodedText)&limit=200&entity=movie&media=movie&country=ru"
    let url = URL(string: urlString)
    return url!
  }
  
  func parse(data: Data) -> [SearchResult] {
    do {
      let decoder = JSONDecoder()
      let result = try decoder.decode(ResultArray.self, from: data)
      return result.results
    } catch {
      print("JSON Error: \(error)")
      return []
    }
  }
  
  func showNetworkError() {
    let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store." + "Please try again.", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  private func testSearch () {
    dataTask?.cancel()
    isLoading = true
    collectionView.reloadData()
    hasSearched = true
    searchResults = []
    let searchText = "Marvel"
    
    let url = iTunesURL(searchText: searchText)
    let session = URLSession.shared
    
    dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
      if let error = error as NSError?, error.code == -999 {
        return
      } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
        if let data = data {
          self.searchResults = self.parse(data: data)
          DispatchQueue.main.async {
            self.isLoading = false
            self.collectionView.reloadData()
          }
          return
        }
      } else {
        print("Failture! \(response!)")
      }
      DispatchQueue.main.async {
        self.hasSearched = false
        self.isLoading = false
        self.collectionView.reloadData()
        self.showNetworkError()
      }
    })
    dataTask?.resume()
  }
  
  // MARK: Safe And Load Data
  func saveResults() {
    print("Documents folder is \(documentsDirectory())")
    print("Data file path is \(dataFilePath())")
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(libraryItems)
      try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
    } catch {
      print("Error encoding item array!")
    }
  }
  
  func loadResults() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = JSONDecoder()
      do {
        libraryItems = try decoder.decode([SearchResult].self, from: data)
      } catch {
        print("Error decoding item array!")
      }
    }
  }
  
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    return paths[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Result.json")
  }
  
}


// MARK:- Search Bar
extension FirstViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("The search text is: '\(searchBar.text!)'")
    performSearch(searchBar: searchBar)
  }
  
  func performSearch(searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      dataTask?.cancel()
      isLoading = true
      collectionView.reloadData()
      hasSearched = true
      searchResults = []
      
      let url = iTunesURL(searchText: searchBar.text!)
      let session = URLSession.shared
      
      dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
        if let error = error as NSError?, error.code == -999 {
          return
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
          if let data = data {
            self.searchResults = self.parse(data: data)
            DispatchQueue.main.async {
              self.isLoading = false
              self.collectionView.reloadData()
            }
            return
          }
        } else {
          print("Failture! \(response!)")
        }
        DispatchQueue.main.async {
          self.hasSearched = false
          self.isLoading = false
          self.collectionView.reloadData()
          self.showNetworkError()
        }
      })
      dataTask?.resume()
    }
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}


// MARK:- Collection View Delegate
extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if isLoading {
      return 9
    } else if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if isLoading {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.loadingCell, for: indexPath)
      let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else if searchResults.count == 0 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.nothingFoundCell, for: indexPath)
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! SearchResultCell
      let searchResult = searchResults[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    collectionView.deselectItem(at: indexPath, animated: true)
    performSegue(withIdentifier: "ShowDetailView", sender: indexPath)
    // Add item to the Library
//    let index = indexPath.row
//    var contains = false
//    for item in libraryItems {
//      if item.trackName == searchResults[index].trackName {
//        contains = true
//      }
//    }
//    if !contains {
//      libraryItems.append(searchResults[index])
//      saveResults()
//    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    if (kind == UICollectionElementKindSectionHeader) {
      let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)
      
      return headerView
    }
    
    return UICollectionReusableView()
    
  }
  
}




