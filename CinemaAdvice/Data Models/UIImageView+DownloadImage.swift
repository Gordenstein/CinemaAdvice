//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Hero on 03.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit

extension UIImageView {
  func loadImage(url: URL) -> URLSessionDownloadTask {
    let session = URLSession.shared
    
    let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, responce, error in
      if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        DispatchQueue.main.async {
          if let weakSelf = self {
            weakSelf.image = image
          }
        }
      }
    })
    downloadTask.resume()
    return downloadTask
  }
}
