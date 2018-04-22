//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Hero on 21.03.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import Foundation


class SearchResult:Codable, CustomStringConvertible {
 
  var artistName = ""
  var trackName:String?
  var kind:String?
  var itemGenre:String?
  var contentAdvisoryRating:String?
  var longDescription:String?
  var imageLarge = ""
  var collectionName:String?
  var opinion:Bool?
  
  enum CodingKeys: String, CodingKey {
    case imageLarge = "artworkUrl100"
    case itemGenre = "primaryGenreName"
    case artistName, trackName, longDescription, kind, contentAdvisoryRating, opinion
  }
  
  var name:String {
    return trackName ?? collectionName ?? ""
  }

  var genre:String {
    if let genre = itemGenre {
      return genre
    } else {
      return ""
    }
  }
  
  var description: String {
    return "Kind: \(kind ?? ""), Name: \(name), Artist Name: \(artistName) \n"
  }
}

class ResultArray:Codable {
  var resultCount = 0
  var results = [SearchResult]()
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}





