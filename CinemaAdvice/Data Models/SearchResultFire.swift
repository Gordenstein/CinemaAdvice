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
  let nameEn: String?
  let imageUrl: String
  let year: Int
  let countries: [String]
  let tagline: String
  let directors: [String]?
  let producers: [String]?
  let genres: [String]
  let budget: String?
  let ageLimit: Int?
  let ratingKinopoisk: NSNumber
  let ratingMpaa: String?
  let duration: Int
  let actors: [String]?
  let description: String
  let keywords: [String]?

  let key: String
  var ref: DatabaseReference?

  var opinion: Bool?

  init(snapshot: DataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    nameRu = snapshotValue[Constants.nameRu] as! String
    nameEn = snapshotValue[Constants.nameEn] as! String?
    imageUrl = snapshotValue[Constants.imageUrl] as! String
    year = snapshotValue[Constants.year] as! Int
    countries = snapshotValue[Constants.countries] as! [String]
    tagline = snapshotValue[Constants.tagline] as! String
    directors = snapshotValue[Constants.directors] as! [String]?
    producers = snapshotValue[Constants.producers] as! [String]?
    genres = snapshotValue[Constants.genres] as! [String]
    budget = snapshotValue[Constants.budget] as! String?
    ageLimit = snapshotValue[Constants.ageLimit] as! Int?
    ratingKinopoisk = snapshotValue[Constants.ratingKinopoisk] as! NSNumber
    ratingMpaa = snapshotValue[Constants.ratingMpaa] as! String?
    duration = snapshotValue[Constants.duration] as! Int
    actors = snapshotValue[Constants.actors] as! [String]?
    description = snapshotValue[Constants.description] as! String
    opinion = snapshotValue[Constants.opinion] as! Bool?
    keywords = snapshotValue[Constants.keywords] as! [String]?
    ref = snapshot.ref
  }

  func getDuration() -> String {
    let minutes: Int
    let hours: Int
    hours = duration / 60
    minutes = duration - 60 * hours
    return String(hours) + ":" + String(minutes)
  }
}
