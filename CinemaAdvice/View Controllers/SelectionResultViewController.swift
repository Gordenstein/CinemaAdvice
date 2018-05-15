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
  
  var libraryItems: [SearchResultFire] = []
  var searchResultFire: [SearchResultFire] = []
  var downloadTask: URLSessionDownloadTask?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    let libraryReference = Database.database().reference(withPath: "library-")
    let searchResultReference = Database.database().reference(withPath: "films")
    
    libraryReference.observe(.value) { (snapshot) in
      var newItems: [SearchResultFire] = []
      for item in snapshot.children {
        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
        newItems.append(searchItem)
      }
      self.libraryItems = newItems
    }
    
    searchResultReference.observe(.value) { (snapshot) in
      var newItems: [SearchResultFire] = []
      for item in snapshot.children {
        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
        newItems.append(searchItem)
      }
      self.searchResultFire = newItems
      self.updateUI()
    }
    
  }
  
  func updateUI() {
    let numberOfFilms = Int(arc4random_uniform(999))
    let searchItem = searchResultFire[numberOfFilms]
    
    nameRu.text = searchItem.nameRu
    if let nameEn = searchItem.nameEn  {
      nameEnAndYear.text = nameEn + "(" + String(searchItem.year) + ")"
    } else {
      nameEnAndYear.text = "(" + String(searchItem.year) + ")"
    }
    var temporaryString = ""
    for genre in searchItem.genres {temporaryString += genre + ", "}
    genres.text = temporaryString
    temporaryString = ""
    for country in searchItem.countries {temporaryString += country + ", "}
    countriesAndDuration.text = temporaryString + String(searchItem.duration)
    tagline.text = searchItem.tagline
    temporaryString = ""
    temporaryString += String(searchItem.ageLimit ?? 0) + "+    " + String(searchItem.ratingMpaa ?? "")
    ageAndMpaa.text = temporaryString
    ratingKinopoisk.text = String(Double(searchItem.ratingKinopoisk))
    filmDescription.text = searchItem.description
    if let largeURL = URL(string: searchItem.imageUrl) {
      downloadTask = artwork.loadImage(url: largeURL)
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.default
  }
}
