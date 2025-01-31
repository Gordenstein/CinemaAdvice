//
//  MovieInfoViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 20.04.2018.
//  Copyright © 2018 Eugene Gordenstein. All rights reserved.
//

import UIKit
import Firebase

class MovieInfoViewController: UIViewController {
  // MARK: Outlets
  @IBOutlet weak var artworkImage: UIImageView!
  @IBOutlet weak var titleLabelRu: UILabel!
  @IBOutlet weak var titleLabelEn: UILabel!
  @IBOutlet weak var genresLabel: UILabel!
  @IBOutlet weak var countriesLabel: UILabel!
  @IBOutlet weak var ageAndMpaa: UILabel!
  @IBOutlet weak var longDescription: UITextView!
  @IBOutlet weak var tagline: UILabel!

  @IBOutlet weak var noButton: UIButton!
  @IBOutlet weak var yesButton: UIButton!
  @IBOutlet weak var doNotWatchButton: UIButton!

  // MARK: Actions
  @IBAction func noButton(_ sender: Any) {
    searchResult.opinion = false
    if let opinion = searchResult.opinion {
      recordItem(opinion: opinion)
    } else {
      print("Opinion is nil.")
    }
    navigationController?.popViewController(animated: true)
  }
  @IBAction func yesButton(_ sender: Any) {
    searchResult.opinion = true
    if let opinion = searchResult.opinion {
      recordItem(opinion: opinion)
    } else {
      print("Opinion is nil.")
    }
    navigationController?.popViewController(animated: true)
  }

  @IBAction func doNotWatchButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }

  // MARK: Start
  var downloadTask: URLSessionDownloadTask?
  var searchResult: Movie!
  var libraryItems: [Movie] = []

  let libraryReference = Database.database().reference(withPath: Constants.usersFavoriteFilmsPath)
  var currentUserReference = Database.database().reference()

  override func viewDidLoad() {
    super.viewDidLoad()
    noButton.layer.cornerRadius = 5
    yesButton.layer.cornerRadius = 5
    doNotWatchButton.layer.cornerRadius = 5
    if searchResult != nil {
      updateUI()
    }
    let userDefaults = UserDefaults.standard
    if let userFavoriteFilmsPath = userDefaults.object(forKey: Constants.userFavoriteFilmsPathKey) as? String {
      self.currentUserReference = self.libraryReference.child(userFavoriteFilmsPath)
    } else {
      // Error - Log out
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func recordItem( opinion: Bool) {
    let libraryItemReference = currentUserReference.child(searchResult.key)
    let values: [String: Any] = [Constants.nameRu: searchResult.nameRu,
                                 Constants.nameEn: searchResult.nameEn ?? "",
                                 Constants.imageUrl: searchResult.imageUrl,
                                 Constants.year: searchResult.year,
                                 Constants.countries: searchResult.countries,
                                 Constants.tagline: searchResult.tagline,
                                 Constants.directors: searchResult.directors ?? [],
                                 Constants.producers: searchResult.producers ?? [],
                                 Constants.genres: searchResult.genres,
                                 Constants.budget: searchResult.budget ?? "",
                                 Constants.ageLimit: searchResult.ageLimit ?? 0,
                                 Constants.ratingKinopoisk: searchResult.ratingKinopoisk,
                                 Constants.ratingMpaa: searchResult.ratingMpaa ?? "",
                                 Constants.duration: searchResult.duration,
                                 Constants.actors: searchResult.actors ?? [],
                                 Constants.description: searchResult.description,
                                 Constants.keywords: searchResult.keywords ?? [],
                                 Constants.opinion: searchResult.opinion ?? true]
    libraryItemReference.setValue(values)

  }

  func updateUI() {
    titleLabelRu.text = searchResult.nameRu
    if let nameEn = searchResult.nameEn {
      titleLabelEn.text = nameEn + "(" + String(searchResult.year) + ")"
    } else {
      titleLabelEn.text = "(" + String(searchResult.year) + ")"
    }
    var temporaryString = ""
    var countOfGenres = searchResult.genres.count
    for genre in searchResult.genres {
      if countOfGenres == 1 {
        temporaryString += genre
      } else {
        temporaryString += genre + ", "
      }
      countOfGenres -= 1
    }
    genresLabel.text = temporaryString
    temporaryString = ""
    for country in searchResult.countries {temporaryString += country + ", "}
    countriesLabel.text = temporaryString + searchResult.getDuration()
    tagline.text = searchResult.tagline
    temporaryString = ""
    temporaryString += String(searchResult.ratingMpaa ?? "") + "  " + String(searchResult.ageLimit ?? 0) + "+"
    ageAndMpaa.text = temporaryString
    longDescription.text = searchResult.description
    if let largeURL = URL(string: searchResult.imageUrl) {
      downloadTask = artworkImage.loadImage(url: largeURL)
    }
  }
}
