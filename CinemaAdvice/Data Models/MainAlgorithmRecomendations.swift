//
//  Selection.swift
//  CinemaAdvice
//
//  Created by Eugene Gordenstein on 1/21/21.
//  Copyright © 2021 Eugene Gordenstein. All rights reserved.
//

import Foundation

struct MainAlgorithmRecomendations {
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
