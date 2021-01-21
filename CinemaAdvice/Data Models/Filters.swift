//
//  Filters.swift
//  CinemaAdvice
//
//  Created by Eugene Gordenstein on 1/21/21.
//  Copyright © 2021 Eugene Gordenstein. All rights reserved.
//

import Foundation

struct Filters {
  static let genresOrder = [Constants.anime,
                            Constants.biography,
                            Constants.action,
                            Constants.western,
                            Constants.wartime,
                            Constants.detective,
                            Constants.documentary,
                            Constants.drama,
                            Constants.history,
                            Constants.comedy,
                            Constants.shortFilm,
                            Constants.crime,
                            Constants.melodrama,
                            Constants.music,
                            Constants.cartoon,
                            Constants.musical,
                            Constants.adventure,
                            Constants.family,
                            Constants.series,
                            Constants.sport,
                            Constants.thriller,
                            Constants.horror,
                            Constants.fantastique,
                            Constants.fantasy]
  
  var startYear: Int
  var endYear: Int
  var startAge: Int
  var endAge: Int
  var genres: [String: Bool] = [Constants.anime: false,
                                Constants.biography: false,
                                Constants.action: false,
                                Constants.western: false,
                                Constants.wartime: false,
                                Constants.detective: false,
                                Constants.documentary: false,
                                Constants.drama: false,
                                Constants.history: false,
                                Constants.comedy: false,
                                Constants.shortFilm: false,
                                Constants.crime: false,
                                Constants.melodrama: false,
                                Constants.music: false,
                                Constants.cartoon: false,
                                Constants.musical: false,
                                Constants.adventure: false,
                                Constants.family: false,
                                Constants.series: false,
                                Constants.sport: false,
                                Constants.thriller: false,
                                Constants.horror: false,
                                Constants.fantastique: false,
                                Constants.fantasy: false]
  
  init () {
    startYear = 1939
    endYear = 2018
    startAge = 0
    endAge = 4
  }
  
  func isEqual(to newFilrers: Filters) -> Bool {
    if self.startYear != newFilrers.startYear ||
        self.endYear != newFilrers.endYear ||
        self.startAge != newFilrers.startAge ||
        self.endAge != newFilrers.endAge {
      return false
    }
    for key in genres.keys {
      if self.genres[key] != newFilrers.genres[key] {
        return false
      }
    }
    return true
  }
  
  func isDefault() -> Bool {
    return self.isEqual(to: Filters())
  }
}
