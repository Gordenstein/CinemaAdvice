//
//  SelectionResultViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 21.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit
import Firebase

class SelectionResultViewController: UIViewController {
  
  @IBOutlet weak var artwork: UIImageView!
  @IBOutlet weak var nameRu: UILabel!
  @IBOutlet weak var nameEnAndYear: UILabel!
  @IBOutlet weak var genres: UILabel!
  @IBOutlet weak var countriesAndDuration: UILabel!
  @IBOutlet weak var tagline: UILabel!
  @IBOutlet weak var ageAndMpaa: UILabel!
  @IBOutlet weak var ratingKinopoisk: UILabel!
  @IBOutlet weak var filmDescription: UITextView!
  @IBOutlet weak var directorsLabel: UILabel!
  @IBOutlet weak var producersLabel: UILabel!
  @IBOutlet weak var actorsLabel: UILabel!
  
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var noButton: UIButton!
  @IBOutlet weak var yesButton: UIButton!
  
  var libraryItems: [SearchResultFire] = []
  var searchResultFire: [SearchResultFire] = []
  var downloadTask: URLSessionDownloadTask?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refreshButton.layer.cornerRadius = 5
    noButton.layer.cornerRadius = 5
    yesButton.layer.cornerRadius = 5
    
    let libraryReference = Database.database().reference(withPath: "library-")
    var searchResultReference = Database.database().reference(withPath: "films")
    
    searchResultReference = searchResultReference.child("100")

//    libraryReference.observe(.value) { (snapshot) in
//      var newItems: [SearchResultFire] = []
//      for item in snapshot.children {
//        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
//        newItems.append(searchItem)
//      }
//      self.libraryItems = newItems
//    }
    
    searchResultReference.observe(.value) { (snapshot) in
      var newItems: [SearchResultFire] = []
//      for item in snapshot.children {
//        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
//        newItems.append(searchItem)
//      }
      
      let searchItem = SearchResultFire(snapshot: snapshot )
      newItems.append(searchItem)
      
      self.searchResultFire = newItems
      self.updateUI()
    }
  }
  
  func updateUI() {
//    let numberOfFilms = Int(arc4random_uniform(999))
    let numberOfFilms = 0
    let searchItem = searchResultFire[numberOfFilms]
    
    nameRu.text = searchItem.nameRu
    if let nameEn = searchItem.nameEn  {
      nameEnAndYear.text = nameEn + "(" + String(searchItem.year) + ")"
    } else {
      nameEnAndYear.text = "(" + String(searchItem.year) + ")"
    }
    var temporaryString = ""
    genres.text = fillString(searchItem.genres)
    temporaryString = ""
    for country in searchItem.countries {temporaryString += country + ", "}
    countriesAndDuration.text = temporaryString + searchItem.getDuration()
    tagline.text = searchItem.tagline
    temporaryString = ""
    temporaryString += String(searchItem.ratingMpaa ?? "") + "   " + String(searchItem.ageLimit ?? 0) + "+"
    ageAndMpaa.text = temporaryString
    ratingKinopoisk.text = String(round(Double(truncating: searchItem.ratingKinopoisk) * 10)/10)
    filmDescription.text = searchItem.description
    if let directors = searchItem.directors {
      directorsLabel.text = fillString(directors)
    } else {
      directorsLabel.text = "Неизвестно"
    }
    if let producers = searchItem.producers {
      producersLabel.text = fillString(producers)
    } else {
      producersLabel.text = "Неизвестно"
    }
    if let actors = searchItem.actors {
      actorsLabel.text = fillString(actors)
    } else {
      actorsLabel.text = "Неизвестно"
    }
    if let largeURL = URL(string: searchItem.imageUrl) {
      downloadTask = artwork.loadImage(url: largeURL)
    }
  }
  
  func fillString(_ items: [String]) -> String {
    var temporaryString = ""
    var countOfItems = items.count
    for item in items {
      if countOfItems == 1 {
        temporaryString += item
      } else {
        temporaryString += item + ", "
      }
      countOfItems -= 1
    }
    return temporaryString
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.default
  }
}
