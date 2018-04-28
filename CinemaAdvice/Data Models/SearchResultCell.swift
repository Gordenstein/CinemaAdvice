//
//  SearchResultCell.swift
//  CinemaAdvice
//
//  Created by Hero on 12.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {

  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  
  var downloadTask: URLSessionDownloadTask?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
    selectedBackgroundView = selectedView
  }
  
//  override func setSelected(_ selected: Bool, animated: Bool) {
//    super.setSelected(selected, animated: animated)
//
//    // Configure the view for the selected state
//  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    downloadTask?.cancel()
    downloadTask = nil
  }
  
  //MARK: Public Methods
  func configure(for result: SearchResult) {
    titleLabel.adjustsFontForContentSizeCategory = true
    genreLabel.adjustsFontForContentSizeCategory = true
    titleLabel.text = result.name

    if result.artistName.isEmpty {
      genreLabel.text = "Unknown"
    } else {
      genreLabel.text = result.genre
    }
    imageView.image = UIImage(named: "Placeholder")
    if let largeURL = URL(string: result.imageLarge) {
      downloadTask = imageView.loadImage(url: largeURL)
    }
  }
}
