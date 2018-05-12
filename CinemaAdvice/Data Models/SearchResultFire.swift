//
//  SearchResultFire.swift
//  CinemaAdvice
//
//  Created by Hero on 12.05.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import Foundation
import Firebase

struct SearchResultFire {
  
  let nameRu: String
  let nameEn: String
  let imageUrl: String
  let year: Int
  var countries: [String] = []
  let tagline: String
  var directors: [String] = []
  var producers: [String] = []
  var genres: [String] = []
  let budget: String
  let ageLimit: Int
  let ratingKinopoisk: NSNumber
  let ratingMpaa: String
  let duration: Int
  var actors: [String] = []
  let description: String
  
  let key: String
  var ref: DatabaseReference?
  
  var opinion:Bool?


  init(snapshot: DataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    nameRu = snapshotValue["nameRu"] as! String
    nameEn = snapshotValue["nameEn"] as! String
    imageUrl = snapshotValue["imageUrl"] as! String
    year = snapshotValue["year"] as! Int
    countries = snapshotValue["countries"] as! [String]
    tagline = snapshotValue["tagline"] as! String
    directors = snapshotValue["directors"] as! [String]
    producers = snapshotValue["producers"] as! [String]
    genres = snapshotValue["genres"] as! [String]
    budget = snapshotValue["budget"] as! String
    ageLimit = snapshotValue["ageLimit"] as! Int
    ratingKinopoisk = snapshotValue["ratingKinopoisk"] as! NSNumber
    ratingMpaa = snapshotValue["ratingMpaa"] as! String
    duration = snapshotValue["duration"] as! Int
    actors = snapshotValue["actors"] as! [String]
    description = snapshotValue["description"] as! String
    opinion = snapshotValue["opinion"] as! Bool?
    ref = snapshot.ref
  }
}
