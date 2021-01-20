//
//  User.swift
//  CinemaAdvice
//
//  Created by Hero on 16.05.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import Foundation

struct User {

  let uid: String
  let email: String

  init(authData: User) {
    uid = authData.uid
    email = authData.email
  }

  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}
