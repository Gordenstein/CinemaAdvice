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
  var libraryItems: [SearchResultFire] = []
  var temporaryFlag = true
  let libraryReference = Database.database().reference(withPath: "libraries")
  var currentUserReference = Database.database().reference()
  var user: User!

  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 80
    // Register nib files
    let cellNib = UINib(nibName: libraryCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: libraryCell)
    
    Auth.auth().addStateDidChangeListener {
      auth, user in
      if let user = user {
        self.user = User(uid: user.uid, email: user.email!)
        self.currentUserReference = self.libraryReference.child("library-" + self.user.uid)
        self.downloadData()
      }
    }
    
  }
  
  func downloadData() {
    currentUserReference.observe(.value) { (snapshot) in
      var newItems: [SearchResultFire] = []
      for item in snapshot.children {
        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
        newItems.append(searchItem)
      }
      self.libraryItems = newItems
      self.temporaryFlag = false
      self.tableView.reloadData()
    }
//    tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  

  @IBAction func signoutButtonPressed(_ sender: Any) {
    let user = Auth.auth().currentUser!
    let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
    onlineRef.removeValue { (error, _) in
      if let error = error {
        print("Removing online failed: \(error)")
        return
      }
      do {
        try Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
      } catch (let error) {
        print("Auth sign out failed: \(error)")
      }
    }
  }
}

// MARK: Table View Delegates
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
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    let item = libraryItems[indexPath.row]
    item.ref?.removeValue()
    if editingStyle == .delete {
      libraryItems.remove(at: indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
  }
}
