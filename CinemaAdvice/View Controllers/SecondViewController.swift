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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    button.layer.cornerRadius = 100

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

