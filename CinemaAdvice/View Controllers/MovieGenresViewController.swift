//
//  MovieGenresViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 15.05.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit

protocol MovieGenresViewControllerDelegate: class {
  func finishEditingGenres(_ controller: MovieGenresViewController, newFilters: Filters)
}

class MovieGenresViewController: UITableViewController {

  var filters = Filters()
  weak var delegate: MovieGenresViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewWillDisappear(_ animated: Bool) {
    delegate?.finishEditingGenres(self, newFilters: filters)
  }

  // MARK: Table View Delegates
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filters.genres.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.genreItemCellID, for: indexPath)
    guard let cellLabel = cell.viewWithTag(1002) as? UILabel else {
      return cell
    }
    let genreKey = Filters.genresOrder[indexPath.row]
    cellLabel.text = genreKey
    if filters.genres[genreKey] ?? false {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let genreKey = Filters.genresOrder[indexPath.row]
      if filters.genres[genreKey] ?? false {
        filters.genres[genreKey] = false
        cell.accessoryType = .none
      } else {
        filters.genres[genreKey] = true
        cell.accessoryType = .checkmark
      }
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
