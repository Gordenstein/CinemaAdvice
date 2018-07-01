//
//  DetailViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 20.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
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
  var searchResult: SearchResultFire!
  var libraryItems: [SearchResultFire] = []
  
  let libraryReference = Database.database().reference(withPath: "libraries")
  var currentUserReference = Database.database().reference()
  var user: User!

  override func viewDidLoad() {
    super.viewDidLoad()
    noButton.layer.cornerRadius = 5
    yesButton.layer.cornerRadius = 5
    doNotWatchButton.layer.cornerRadius = 5
    if searchResult != nil {
      updateUI()
    }
    
    Auth.auth().addStateDidChangeListener {
      auth, user in
      if let user = user {
        self.user = User(uid: user.uid, email: user.email!)
        self.currentUserReference = self.libraryReference.child("library-" + self.user.uid)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  func recordItem( opinion: Bool) {
    let libraryItemReference = currentUserReference.child(searchResult.key)
    let values: [String: Any] = ["nameRu": searchResult.nameRu,
                                 "nameEn": searchResult.nameEn ?? "",
                                 "imageUrl": searchResult.imageUrl,
                                 "year": searchResult.year,
                                 "countries": searchResult.countries,
                                 "tagline": searchResult.tagline,
                                 "directors": searchResult.directors ?? [],
                                 "producers": searchResult.producers ?? [],
                                 "genres": searchResult.genres,
                                 "budget": searchResult.budget ?? "",
                                 "ageLimit": searchResult.ageLimit ?? 0,
                                 "ratingKinopoisk": searchResult.ratingKinopoisk,
                                 "ratingMpaa": searchResult.ratingMpaa ?? "",
                                 "duration": searchResult.duration,
                                 "actors": searchResult.actors ?? [],
                                 "description": searchResult.description,
                                 "keywords": searchResult.keywords ?? [],
                                 "opinion": searchResult.opinion ?? true]
    libraryItemReference.setValue(values)
    
  }
  
  func updateUI() {
    titleLabelRu.text = searchResult.nameRu
    if let nameEn = searchResult.nameEn  {
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
