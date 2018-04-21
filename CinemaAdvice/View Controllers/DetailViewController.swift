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
  
  override func viewDidLoad() {
        super.viewDidLoad()

    if searchResult != nil {
      updateUI() }
    
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
