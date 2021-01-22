//
//  MainAlgorithmViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordenstein. All rights reserved.
//

import UIKit
import Firebase

class MainAlgorithmViewController: UIViewController {

  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var warningLabel: UILabel!

  @IBAction func startSelection(_ sender: UIButton) {
    sender.fadeOut()
    performSegue(withIdentifier: Constants.showResultCellID, sender: nil)
  }

  let libraryReference = Database.database().reference(withPath: "libraries")
  let rootReference = Database.database().reference()
  var currentUserReference = Database.database().reference()

  override func viewDidLoad() {
    super.viewDidLoad()
    button.layer.cornerRadius = 100
    warningLabel.text = NSLocalizedString(
      "Counting films in the library...",
      comment: "Localized kind: Идет подсчет фильмов в библиотеке...")
    buttonOff()

    let userDefaults = UserDefaults.standard
    if let userFavoriteFilmsPath = userDefaults.object(forKey: Constants.userFavoriteFilmsPathKey) as? String {
      self.currentUserReference = self.libraryReference.child(userFavoriteFilmsPath)
      self.downloadData()
    } else {
      // Error - Log out
    }
  }

  private func downloadData() {
    currentUserReference.observe(.value) { (snapshot) in
      var countFilms = 0
      for _ in snapshot.children {
        countFilms += 1
      }
      if countFilms < 20 {
        self.warningLabel.text = NSLocalizedString(
          "You didn't add enough movies to run the algorithm. \nYou added: ",
          comment: "Localized kind: Вы не отметили достаточное количество фильмов для работы алгоритма...") +
          String(countFilms) +
          NSLocalizedString(" out of 20.", comment: "Localized kind: из 20.")
        self.buttonOff()
      } else {
        self.warningLabel.text = ""
        self.buttonOn()
      }
    }
  }

  private func buttonOn() {
    button.isEnabled = true
    button.alpha = 1.0
    button.pulsate()
  }

  private func buttonOff() {
    button.isEnabled = false
    button.alpha = 0.4
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewDidAppear(_ animated: Bool) {
    if button.isEnabled {
      button.pulsate()
    }
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
}
