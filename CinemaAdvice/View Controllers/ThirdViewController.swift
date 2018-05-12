//
//  ThirdViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit
import Firebase

class ThirdViewController: UIViewController {

  let libraryCell = "LibraryCell"

//  var libraryItems = [SearchResult]()
//  var hasSearched = false
//  var isLoading = false
//  var dataTask: URLSessionDataTask?
  
  var libraryItems: [SearchResultFire] = []
  var temporaryFlag = true
  
  @IBOutlet weak var tableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 80
    // Register nib files
    let cellNib = UINib(nibName: libraryCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: libraryCell)
  }
  
  override func viewWillAppear(_ animated: Bool) {
//    if let results = loadResults() {
//      libraryItems = results
//    }
    
    let libraryReference = Database.database().reference(withPath: "library-")
    libraryReference.observe(.value) { (snapshot) in
      var newItems: [SearchResultFire] = []
      for item in snapshot.children {
        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
        newItems.append(searchItem)
      }
      self.libraryItems = newItems
      self.temporaryFlag = false
      self.tableView.reloadData()
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
    if temporaryFlag {
      return 0
    } else {
      return libraryItems.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if !temporaryFlag {
      let cell = tableView.dequeueReusableCell(withIdentifier: libraryCell, for: indexPath) as! LibraryCell
      let libraryItem = libraryItems[indexPath.row]
      cell.configure(for: libraryItem)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: libraryCell, for: indexPath) as! LibraryCell
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return indexPath
  }
}
