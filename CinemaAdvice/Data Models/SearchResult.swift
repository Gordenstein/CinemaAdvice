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
  
  
  
  func hello() {
    
  }
}

class ResultArray:Codable {
  var resultCount = 0
  var results = [SearchResult]()
  
  
  func hi() {
    
  }
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}

func saveResults(results: [SearchResult]) {
//  print("Documents folder is \(documentsDirectory())")
//  print("Data file path is \(dataFilePath())")
  print("Save result")
  let encoder = JSONEncoder()
  do {
    let data = try encoder.encode(results)
    try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
  } catch {
    print("Error encoding item array!")
  }
}

func loadResults() -> [SearchResult]? {
  print("Load result")
  let path = dataFilePath()
  if let data = try? Data(contentsOf: path) {
    let decoder = JSONDecoder()
    do {
      let results = try decoder.decode([SearchResult].self, from: data)
      return results
    } catch {
      print("Error decoding item array!")
    }
  }
  return nil
}

func documentsDirectory() -> URL {
  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  return paths[0]
}

func dataFilePath() -> URL {
  return documentsDirectory().appendingPathComponent("Result.json")
}





