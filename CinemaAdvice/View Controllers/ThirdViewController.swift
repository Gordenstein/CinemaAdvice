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
//    tableView.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
    tableView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if let results = loadResults() {
      libraryItems = results
    }
    tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
