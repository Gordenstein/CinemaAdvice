//
//  DetailViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 20.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var artworkImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var collectionTitleLabel: UILabel!
  @IBOutlet weak var artistLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var contentAdvisoryRating: UILabel!
  @IBOutlet weak var longDescription: UITextView!
  
  var searchResult: SearchResult!
  var downloadTask: URLSessionDownloadTask?
  var libraryItems = [SearchResult]()
  

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
  
  override func viewDidLoad() {
        super.viewDidLoad()
    if searchResult != nil {
      updateUI()
    }
    if let results = loadResults() {
      libraryItems = results
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func recordItem( opinion: Bool) {  // Remaster
    var contains = false
    for (index,item) in libraryItems.enumerated() {
      if item.trackName == searchResult.trackName {
        libraryItems.remove(at: index)
        item.opinion = opinion
        libraryItems.append(searchResult)
        contains = true
      }
    }
    if !contains {
      libraryItems.append(searchResult)
    }
    saveResults(results: libraryItems)
  }

  func updateUI() {
    titleLabel.text = searchResult.trackName
    collectionTitleLabel.text = searchResult.collectionName
    contentAdvisoryRating.text = searchResult.contentAdvisoryRating
    longDescription.text = searchResult.longDescription

    if searchResult.artistName.isEmpty {
      artistLabel.text = "Unknown"
    } else {
      artistLabel.text = searchResult.artistName
    }
    genreLabel.text = searchResult.genre
    if let largeURL = URL(string: searchResult.imageLarge) {
      downloadTask = artworkImage.loadImage(url: largeURL)
    }
  }
}
