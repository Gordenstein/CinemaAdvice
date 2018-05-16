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
  
  var opinion:Bool?


  init(snapshot: DataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    nameRu = snapshotValue["nameRu"] as! String
    nameEn = snapshotValue["nameEn"] as! String?
    imageUrl = snapshotValue["imageUrl"] as! String
    year = snapshotValue["year"] as! Int
    countries = snapshotValue["countries"] as! [String]
    tagline = snapshotValue["tagline"] as! String
    directors = snapshotValue["directors"] as! [String]?
    producers = snapshotValue["producers"] as! [String]?
    genres = snapshotValue["genres"] as! [String]
    budget = snapshotValue["budget"] as! String?
    ageLimit = snapshotValue["ageLimit"] as! Int?
    ratingKinopoisk = snapshotValue["ratingKinopoisk"] as! NSNumber
    ratingMpaa = snapshotValue["ratingMpaa"] as! String?
    duration = snapshotValue["duration"] as! Int
    actors = snapshotValue["actors"] as! [String]?
    description = snapshotValue["description"] as! String
    opinion = snapshotValue["opinion"] as! Bool?
    keywords = snapshotValue["keywords"] as! [String]?
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
    startYear = 1960
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
