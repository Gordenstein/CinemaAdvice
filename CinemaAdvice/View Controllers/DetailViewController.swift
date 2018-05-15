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
  @IBOutlet weak var artistLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var contentAdvisoryRating: UILabel!
  @IBOutlet weak var longDescription: UITextView!

  
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
  
  func recordItem( opinion: Bool) {
    let libraryReference = Database.database().reference(withPath: "library-")
    let libraryItemReference = libraryReference.child(searchResult.key)
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
  
  // MARK: Start
  var downloadTask: URLSessionDownloadTask?
  var searchResult: SearchResultFire!
  var libraryItems: [SearchResultFire] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if searchResult != nil {
      updateUI()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func updateUI() {
    titleLabelRu.text = searchResult.nameRu
    titleLabelEn.text = searchResult.nameEn
//    artistLabel.text = searchResult.directors[0]
    contentAdvisoryRating.text = String(searchResult.ageLimit ?? 100)
    longDescription.text = searchResult.description
    genreLabel.text = searchResult.genres[0]
    if let largeURL = URL(string: searchResult.imageUrl) {
      downloadTask = artworkImage.loadImage(url: largeURL)
    }
  }
}
