//
//  GenresViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 15.05.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit


protocol GenresViewControllerDelegate: class {
  func finishEditing(_ controller: GenresViewController, newFilters: Filters)
}

class GenresViewController: UITableViewController {
  
  var filters = Filters()
  weak var delegate: GenresViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    delegate?.finishEditing(self, newFilters: filters)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filters.genres.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GenreItem", for: indexPath)
    let cellTitle = cell.viewWithTag(1002) as! UILabel
    cellTitle.text = filters.genres[indexPath.row].0
    if filters.genres[indexPath.row].1 {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      if filters.genres[indexPath.row].1 {
        filters.genres[indexPath.row].1 = false
      } else {
        filters.genres[indexPath.row].1 = true
      }
      
      if filters.genres[indexPath.row].1 {
        cell.accessoryType = .checkmark
      } else {
        cell.accessoryType = .none
      }
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
