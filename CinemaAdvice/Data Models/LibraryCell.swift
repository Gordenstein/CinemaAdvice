//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Hero on 23.03.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit

class LibraryCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!
  
  var downloadTask: URLSessionDownloadTask?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
    selectedBackgroundView = selectedView
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    downloadTask?.cancel()
    downloadTask = nil
  }
  
  //MARK: Public Methods
  func configure(for result: SearchResult) {
    nameLabel.adjustsFontForContentSizeCategory = true
    genreLabel.adjustsFontForContentSizeCategory = true
    nameLabel.text = result.name
    
    if result.artistName.isEmpty {
      genreLabel.text = "Unknown"
    } else {
      genreLabel.text = String(format: "%@ (%@)", result.artistName, result.genre)
    }
    artworkImageView.image = UIImage(named: "Placeholder")
    if let largeURL = URL(string: result.imageLarge) {
      downloadTask = artworkImageView.loadImage(url: largeURL)
    }
  }
}
