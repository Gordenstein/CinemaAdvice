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
  
  @IBOutlet weak var artworkImage: UIImageView!
  @IBOutlet weak var titleLabelRu: UILabel!
  @IBOutlet weak var titleLabelEn: UILabel!
  @IBOutlet weak var artistLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var contentAdvisoryRating: UILabel!
  @IBOutlet weak var longDescription: UITextView!
  
  //  var searchResult: SearchResult!
  //  var libraryItems = [SearchResult]()
  
  var downloadTask: URLSessionDownloadTask?
  var searchResult: SearchResultFire!
  var libraryItems: [SearchResultFire] = []
  
  
  
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
  
  func recordItem( opinion: Bool) {  // Remaster
    //    var contains = false
    //    for (index,item) in libraryItems.enumerated() {
    //      if item.trackName == searchResult.trackName {
    //        libraryItems.remove(at: index)
    //        item.opinion = opinion
    //        libraryItems.append(searchResult)
    //        contains = true
    //      }
    //    }
    //    if !contains {
    //      libraryItems.append(searchResult)
    //    }
    //    saveResults(results: libraryItems)
    let libraryReference = Database.database().reference(withPath: "library-")
    let libraryItemReference = libraryReference.child(searchResult.key)
    let values: [String: Any] = ["nameRu": searchResult.nameRu,
                                 "nameEn": searchResult.nameEn,
                                 "imageUrl": searchResult.imageUrl,
                                 "year": searchResult.year,
                                 "countries": searchResult.countries,
                                 "tagline": searchResult.tagline,
                                 "directors": searchResult.directors,
                                 "producers": searchResult.producers,
                                 "genres": searchResult.genres,
                                 "budget": searchResult.budget,
                                 "ageLimit": searchResult.ageLimit,
                                 "ratingKinopoisk": searchResult.ratingKinopoisk,
                                 "ratingMpaa": searchResult.ratingMpaa,
                                 "duration": searchResult.duration,
                                 "actors": searchResult.actors,
                                 "description": searchResult.description,
                                 "keywords": searchResult.keywords,
                                 "opinion": searchResult.opinion ?? true]
    libraryItemReference.setValue(values)
    
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if searchResult != nil {
      updateUI()
    }
    //    if let results = loadResults() {
    //      libraryItems = results
    //    }
    
    
    
    //    let libraryReference = Database.database().reference(withPath: "library-")
    //    libraryReference.observe(.value) { (snapshot) in
    //      var newItems: [SearchResultFire] = []
    //      for item in snapshot.children {
    //        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
    //        newItems.append(searchItem)
    //      }
    //      self.libraryItems = newItems
    //      self.temporaryFlag = false
    //      self.tableView.reloadData()
    //    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
