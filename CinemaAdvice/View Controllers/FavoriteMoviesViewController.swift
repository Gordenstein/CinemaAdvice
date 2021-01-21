//
//  ThirdViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit
import Firebase

class FavoriteMoviesViewController: UIViewController {

  var libraryItems: [SearchResultFire] = []
  var hasSearched = false
  let libraryReference = Database.database().reference(withPath: Constants.usersFavoriteFilmsPath)
  var currentUserReference = Database.database().reference()

  @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 80
    // Register nib files
    let cellNib = UINib(nibName: Constants.libraryCellID, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: Constants.libraryCellID)
    
    let userDefaults = UserDefaults.standard
    if let userFavoriteFilmsPath = userDefaults.object(forKey: Constants.userFavoriteFilmsPathKey) as? String {
      self.currentUserReference = self.libraryReference.child(userFavoriteFilmsPath)
      self.downloadData()
    } else {
      // Error - Log out
    }
  }

  private func downloadData() {
    currentUserReference.observe(.value) { (snapshot) in
      var newItems: [SearchResultFire] = []
      for item in snapshot.children {
        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
        newItems.append(searchItem)
      }
      self.libraryItems = newItems
      self.hasSearched = true
      self.tableView.reloadData()
      self.leftBarButtonItem.title? = String(self.libraryItems.count)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func signoutButtonPressed(_ sender: Any) {
    let userDefaults = UserDefaults.standard
    guard let userID = userDefaults.object(forKey: Constants.userIDKey) as? String else {
      self.dismiss(animated: true, completion: nil)
      return
    }
    let onlineReference = Database.database().reference(withPath: Constants.usersPathPrefix + userID)
    onlineReference.removeValue { (error, _) in
      if let error = error {
        print("Removing online failed: \(error)")
      }
      do {
        try Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
      } catch let error {
        print("Auth sign out failed: \(error)")
      }
    }
  }
}

// MARK: Table View Delegates
extension FavoriteMoviesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !hasSearched {
      return 0
    } else {
      return libraryItems.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if hasSearched {
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.libraryCellID, for: indexPath) as! LibraryCell
      let libraryItem = libraryItems[indexPath.row]
      cell.configure(for: libraryItem)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.libraryCellID, for: indexPath) as! LibraryCell
      return cell
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return indexPath
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let item = libraryItems[indexPath.row]
    item.ref?.removeValue()
    if editingStyle == .delete {
      libraryItems.remove(at: indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
  }
}
