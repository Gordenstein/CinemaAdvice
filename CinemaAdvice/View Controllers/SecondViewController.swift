//
//  SecondViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController {
  
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var warningLabel: UILabel!
  
  
  @IBAction func startSelection(_ sender: UIButton) {
    sender.fadeOut()
    performSegue(withIdentifier: "ShowResult", sender: nil)
  }
  
  let libraryReference = Database.database().reference(withPath: "libraries")
  var currentUserReference = Database.database().reference()
  var user: User!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    button.layer.cornerRadius = 100
    warningLabel.text = ""
    button.isEnabled = false
    button.alpha = 0.4
    
    Auth.auth().addStateDidChangeListener {
      auth, user in
      if let user = user {
        self.user = User(uid: user.uid, email: user.email!)
        self.currentUserReference = self.libraryReference.child("library-" + self.user.uid)
        self.downloadData()
      }
    }

  }
  
  func downloadData() {
    currentUserReference.observe(.value) { (snapshot) in
      var newItems: [SearchResultFire] = []
      for item in snapshot.children {
        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
        newItems.append(searchItem)
      }
      if newItems.count < 20 {
        self.warningLabel.text = "Вы не отметили достаточное количество фильмов для работы алгоритма. \nВы отметили: \(newItems.count) из 20."
        self.buttonOff()
      } else {
        self.warningLabel.text = ""
        self.buttonOn()
      }
    }
  }
  
  func buttonOn() {
    button.isEnabled = true
    button.alpha = 1.0
    button.pulsate()
  }
  
  func buttonOff() {
    button.isEnabled = false
    button.alpha = 0.4
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    downloadData()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
}

