//
//  ButtonAnimationExtension.swift
//  CinemaAdvice
//
//  Created by Hero on 23.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
  
  func pulsate() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 160.0
    pulse.fromValue = 1.0
    pulse.toValue = 1.01
    pulse.autoreverses = true
    pulse.repeatCount = 10
    pulse.initialVelocity = 0
    pulse.damping = 0.01
    layer.add(pulse, forKey: "pulse")
  }
  
  func fadeOut() {
    let fade = CABasicAnimation(keyPath: "transform.scale")
    fade.fromValue = 1.0
    fade.toValue = 0.0
    fade.duration = 0.2
    fade.autoreverses = false
    fade.repeatCount = 1
    layer.add(fade, forKey: "fade")
  }
}
