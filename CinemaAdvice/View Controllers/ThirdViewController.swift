//
//  ThirdViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

  let libraryCell = "LibraryCell"

  var libraryItems = [SearchResult]()
  var hasSearched = false
  var isLoading = false
  var dataTask: URLSessionDataTask?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 80
    // Register nib files
    let cellNib = UINib(nibName: libraryCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: libraryCell)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    loadResults()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
}

// MARK: Table View
extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return libraryItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: libraryCell, for: indexPath) as! LibraryCell
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
