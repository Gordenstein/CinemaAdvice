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
  
  //MARK: Public Methods
  func configure(for result: SearchResultFire) {
    nameLabel.adjustsFontForContentSizeCategory = true
    genreLabel.adjustsFontForContentSizeCategory = true
    nameLabel.text = result.nameRu
    
    if result.opinion! {
      opinionImageView.image = #imageLiteral(resourceName: "thumbUp")
    } else {
      opinionImageView.image = #imageLiteral(resourceName: "thumbDown")
    }
    genreLabel.text = String(format: "%@ (%@)", result.genres[0], String(result.year))
    artworkImageView.image = UIImage(named: "Placeholder")
    if let largeURL = URL(string: result.imageUrl) {
      downloadTask = artworkImageView.loadImage(url: largeURL)
    }
  }
}
