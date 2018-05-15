//
//  SecondViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 11.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
  
  @IBOutlet weak var button: UIButton!
  
  
  @IBAction func startSelection(_ sender: UIButton) {
    sender.fadeOut()
    performSegue(withIdentifier: "ShowResult", sender: nil)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    button.layer.cornerRadius = 100
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    button.pulsate()
  }
  
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
}


//extension SecondViewController: UIViewControllerTransitioningDelegate {
//  func animationController(forDismissed dismissed:
//    UIViewController) -> UIViewControllerAnimatedTransitioning? {
//    return TwistOutAnimationController()
//  }
//}

