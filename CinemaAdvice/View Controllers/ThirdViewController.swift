//
//  ThirdViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
  
  struct TableViewCellIdentifiers {
    static let searchResultCell = "LibraryCell"
    static let loadingCell = "LoadingCell"
  }
  
  var libraryItems = [SearchResult]()
  var hasSearched = false
  var isLoading = false
  var dataTask: URLSessionDataTask?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    tableView.rowHeight = 80
    // Register nib files
    let cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
//    cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
//    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
//    testSearch()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    loadResults()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func loadResults() {
    print("Start Load!")
    tableView.reloadData()
    hasSearched = true
    libraryItems = []
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = JSONDecoder()
      do {
        libraryItems = try decoder.decode([SearchResult].self, from: data)
      } catch {
        print("Error decoding item array!")
      }
    }
    tableView.reloadData()
  }
  
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    return paths[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Result.json")
  }
  

//  // MARK: Private Methods
//   private func iTunesURL(searchText: String, category: Int) -> URL {
//    let kind: String
//    switch category {
//    case 1: kind = "musicTrack"
//    case 2: kind = "software"
//    case 3: kind = "ebook"
//    case 4: kind = "movie"
//    default: kind = ""
//    }
//
//    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//
//    let urlString = "https://itunes.apple.com/search?" + "term=\(encodedText)&limit=200&entity=\(kind)"
//    let url = URL(string: urlString)
//    return url!
//  }
//
//  private func parse(data: Data) -> [SearchResult] {
//    do {
//      let decoder = JSONDecoder()
//      let result = try decoder.decode(ResultArray.self, from: data)
//      return result.results
//    } catch {
//      print("JSON Error: \(error)")
//      return []
//    }
//  }
//
//  private func showNetworkError() {
//    let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store." + "Please try again.", preferredStyle: .alert)
//    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//    alert.addAction(action)
//    present(alert, animated: true, completion: nil)
//  }
//
//
//  private func testSearch () {
//    dataTask?.cancel()
//    isLoading = true
//    tableView.reloadData()
//    hasSearched = true
//    searchResults = []
//    let searchText = "Marvel"
//
//    let url = iTunesURL(searchText: searchText, category: 4)
//    let session = URLSession.shared
//
//    dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
//      //        print("On main thread? " + (Thread.current.isMainThread ? "Yes" : "No"))
//      if let error = error as NSError?, error.code == -999 {
//        return
//      } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//        if let data = data {
//          self.searchResults = self.parse(data: data)
//          //            self.searchResults.sort(by: <)
//          DispatchQueue.main.async {
//            self.isLoading = false
//            self.tableView.reloadData()
//          }
//          return
//        }
//      } else {
//        print("Failture! \(response!)")
//      }
//      DispatchQueue.main.async {
//        self.hasSearched = false
//        self.isLoading = false
//        self.tableView.reloadData()
//        self.showNetworkError()
//      }
//    })
//    dataTask?.resume()
//  }
//  
}



// MARK: Table View
extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return libraryItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
      let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! LibraryCell
      let searchResult = libraryItems[indexPath.row]
      cell.configure(for: searchResult)
      return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return indexPath
  }
}
