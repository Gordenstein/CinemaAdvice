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
  var nameEn: String?
  let imageUrl: String
  let year: Int
  var countries: [String] = []
  let tagline: String
  var directors: [String]? = []
  var producers: [String]? = []
  var genres: [String] = []
  let budget: String?
  let ageLimit: Int?
  let ratingKinopoisk: NSNumber
  let ratingMpaa: String?
  let duration: Int
  var actors: [String]? = []
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

struct Filters {

  var startYear: Int
  var endYear: Int
  var startAge: Int
  var endAge: Int
  var genres: [(String, Bool)] = [("аниме", false),
                                  ("биография", false),
                                  ("боевик", false),
                                  ("вестерн", false),
                                  ("военный", false),
                                  ("детектив", false),
                                  ("документальный", false),
                                  ("драма", false),
                                  ("история", false),
                                  ("комедия", false),
                                  ("короткометражка", false),
                                  ("криминал", false),
                                  ("мелодрама", false),
                                  ("музыка", false),
                                  ("мультфильм", false),
                                  ("мюзикл", false),
                                  ("приключения", false),
                                  ("семейный", false),
                                  ("сериал", false),
                                  ("спорт", false),
                                  ("триллер", false),
                                  ("ужасы", false),
                                  ("фантастика", false),
                                  ("фэнтези", false)] // 24

  init () {
    startYear = 1939
    endYear = 2018
    startAge = 0
    endAge = 4
  }

  func changeFilters(first filter1: Filters, second filter2: Filters) -> Bool {
    var change = false
    for item in 0...filter1.genres.count - 1 {
      if filter1.genres[item] != filter2.genres[item] {
        change = true
      }
    }
    if (filter1.startAge != filter2.startAge) || (filter1.endAge != filter2.endAge) ||
      (filter1.startYear != filter2.startYear) || (filter1.endYear != filter2.endYear) {
      change = true
    }
    return change
  }
}

struct Selection {

  var years: [(Int, Int)]
  var directors: [(String, Int)]
  var countries: [(String, Int)]
  var actors: [(String, Int)]
  var genres: [(String, Int)]
  var keywords: [(String, Int)]

  init() {
    years = []
    directors = []
    countries = []
    actors = []
    genres = []
    keywords = []
  }

}
