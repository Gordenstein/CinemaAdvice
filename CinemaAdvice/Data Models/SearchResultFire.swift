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
    self.key = snapshot.key
    guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
      self.nameRu = String()
      self.nameEn = String()
      self.imageUrl = String()
      self.year = Int()
      self.countries = [String]()
      self.tagline = String()
      self.directors = [String]()
      self.producers = [String]()
      self.genres = [String]()
      self.budget = String()
      self.ageLimit = Int()
      self.ratingKinopoisk = NSNumber()
      self.ratingMpaa = String()
      self.duration = Int()
      self.actors = [String]()
      self.description = String()
      self.opinion = Bool()
      self.keywords = [String]()
      return
    }
    self.nameRu = snapshotValue[Constants.nameRu] as? String ?? String()
    self.nameEn = snapshotValue[Constants.nameEn] as? String
    self.imageUrl = snapshotValue[Constants.imageUrl] as? String ?? String()
    self.year = snapshotValue[Constants.year] as? Int ?? Int()
    self.countries = snapshotValue[Constants.countries] as? [String] ?? [String]()
    self.tagline = snapshotValue[Constants.tagline] as? String ?? String()
    self.directors = snapshotValue[Constants.directors] as? [String] ?? [String]()
    self.producers = snapshotValue[Constants.producers] as? [String] ?? [String]()
    self.genres = snapshotValue[Constants.genres] as? [String] ?? [String]()
    self.budget = snapshotValue[Constants.budget] as? String ?? String()
    self.ageLimit = snapshotValue[Constants.ageLimit] as? Int ?? Int()
    self.ratingKinopoisk = snapshotValue[Constants.ratingKinopoisk] as? NSNumber ?? NSNumber()
    self.ratingMpaa = snapshotValue[Constants.ratingMpaa] as? String ?? String()
    self.duration = snapshotValue[Constants.duration] as? Int ?? Int()
    self.actors = snapshotValue[Constants.actors] as? [String] ?? [String]()
    self.description = snapshotValue[Constants.description] as? String ?? String()
    self.opinion = snapshotValue[Constants.opinion] as? Bool ?? Bool()
    self.keywords = snapshotValue[Constants.keywords] as? [String] ?? [String]()
    self.ref = snapshot.ref
  }

  func getDuration() -> String {
    let minutes: Int
    let hours: Int
    hours = duration / 60
    minutes = duration - 60 * hours
    return String(hours) + ":" + String(minutes)
  }
}
