//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Hero on 23.03.2018.
//  Copyright © 2018 Eugene Gordenstein. All rights reserved.
//

import UIKit

class LibraryCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var opinionImageView: UIImageView!

  var downloadTask: URLSessionDownloadTask?

  override func awakeFromNib() {
    super.awakeFromNib()
    let selection = UIView(frame: CGRect.zero)
    selection.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
    selectedBackgroundView = selection
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    downloadTask?.cancel()
    downloadTask = nil
  }

  // MARK: Public Methods
  func configure(for result: Movie) {
    nameLabel.adjustsFontForContentSizeCategory = true
    genreLabel.adjustsFontForContentSizeCategory = true
    if #available(iOS 13.0, *) {
        nameLabel.textColor = UIColor.label
        genreLabel.textColor = UIColor.secondaryLabel
    } else {
        // Fallback on earlier versions
    }
    nameLabel.text = result.nameRu

    if result.opinion! {
      opinionImageView.image = UIImage(systemName: "star.fill")
    } else {
      opinionImageView.image = UIImage(systemName: "star")
    }
    opinionImageView.tintColor = UIColor.systemOrange
    genreLabel.text = String(format: "%@ (%@)", result.genres[0], String(result.year))
    artworkImageView.image = UIImage(named: "Placeholder")
    if let largeURL = URL(string: result.imageUrl) {
      downloadTask = artworkImageView.loadImage(url: largeURL)
    }
  }
}
