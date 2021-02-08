//
//  MovieGenresViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 15.05.2018.
//  Copyright © 2018 Eugene Gordenstein. All rights reserved.
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
    let internationalKey = getInternationalGenreName(genreID: genreKey)
    let cellText = NSLocalizedString(internationalKey, comment: "Genre")
    cellLabel.text = cellText
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

  // swiftlint:disable:next cyclomatic_complexity function_body_length
  func getInternationalGenreName(genreID: String) -> String {
    switch genreID {
    case "аниме":
      return "anime"
    case "биография":
      return "biography"
    case "боевик":
      return "action"
    case "вестерн":
      return "western"
    case "военный":
      return "wartime"
    case "детектив":
      return "detective"
    case "документальный":
      return "documentary"
    case "драма":
      return "drama"
    case "история":
      return "history"
    case "комедия":
      return "comedy"
    case "короткометражка":
      return "shortFilm"
    case "криминал":
      return "crime"
    case "мелодрама":
      return "melodrama"
    case "музыка":
      return "music"
    case "мультфильм":
      return "cartoon"
    case "мюзикл":
      return "musical"
    case "приключения":
      return "adventure"
    case "семейный":
      return "family"
    case "сериал":
      return "series"
    case "спорт":
      return "sport"
    case "триллер":
      return "thriller"
    case "ужасы":
      return "horror"
    case "фантастика":
      return "fantastique"
    case "фэнтези":
      return "fantasy"
    default:
      return "unknown"
    }
  }
}
