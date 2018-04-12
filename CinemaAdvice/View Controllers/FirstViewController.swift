//
//  FirstViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  
  var searchResults = [SearchResult]()
  var hasSearched = false
  var isLoading = false
  var dataTask: URLSessionDataTask?
  
  var downloadTask: URLSessionDownloadTask?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
    testSearch()
    searchBar.becomeFirstResponder()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Private Methods
  func iTunesURL(searchText: String) -> URL {
    
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    
    let urlString = "https://itunes.apple.com/search?" + "term=\(encodedText)&limit=200&entity=movie"
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
  
  
}


// MARK:- Search Bar
extension FirstViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("The search text is: '\(searchBar.text!)'")
    performSearch()
  }
  
  func performSearch() {
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
      return 1
    } else if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if hasSearched && !isLoading {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! SearchResultCell
      let searchResult = searchResults[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! SearchResultCell
      return cell
    }
  }
  
}




