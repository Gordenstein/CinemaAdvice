//
//  SelectionResultViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 21.04.2018.
//  Copyright © 2018 Eugene Gordeev. All rights reserved.
//

import UIKit
import Firebase

class SelectionResultViewController: UIViewController {
  
  @IBOutlet weak var artwork: UIImageView!
  @IBOutlet weak var nameRu: UILabel!
  @IBOutlet weak var nameEnAndYear: UILabel!
  @IBOutlet weak var genres: UILabel!
  @IBOutlet weak var countriesAndDuration: UILabel!
  @IBOutlet weak var tagline: UILabel!
  @IBOutlet weak var ageAndMpaa: UILabel!
  @IBOutlet weak var ratingKinopoisk: UILabel!
  @IBOutlet weak var filmDescription: UITextView!
  @IBOutlet weak var directorsLabel: UILabel!
  @IBOutlet weak var producersLabel: UILabel!
  @IBOutlet weak var actorsLabel: UILabel!
  
  @IBOutlet weak var titleRatingKP: UILabel!
  @IBOutlet weak var titleDirectors: UILabel!
  @IBOutlet weak var titleProducers: UILabel!
  @IBOutlet weak var titleActors: UILabel!
  @IBOutlet weak var grayView: UIView!
  
  
  @IBOutlet weak var pleaseWaitLabel: UILabel!
  @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var noButton: UIButton!
  @IBOutlet weak var yesButton: UIButton!
  
  var libraryItems: [SearchResultFire] = []
  var wholeData: [SearchResultFire] = []
  var finishArray: [SearchResultFire] = []
  var filmNumber = -1
  var downloadTask: URLSessionDownloadTask?
  let libraryReference = Database.database().reference(withPath: "libraries")
  var currentUserReference = Database.database().reference()
  var user: User!
  var selectionArray = Selection()
  var mustLoad = true
  var firstTime = true
  
  let testShot = false
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refreshButton.layer.cornerRadius = 5
    noButton.layer.cornerRadius = 5
    yesButton.layer.cornerRadius = 5
    startLoading()
    
    Auth.auth().addStateDidChangeListener {
      auth, user in
      if let user = user {
        self.user = User(uid: user.uid, email: user.email!)
        self.currentUserReference = self.libraryReference.child("library-" + self.user.uid)
        if self.firstTime {
          self.firstTime = false
          self.downloadFilms()
        }
      }
    }
  }
  
  func controlSelection() {
    //    for i in 1...10 {
    //      printState = 0
    //      numberOfYear = i
    //      useSelectionArray()
    //    }
    //    print("----------------------------------------")
    //    for i in 1...10 {
    //      printState = 1
    //      numberOfDirectors = i
    //      useSelectionArray()
    //    }
    //    print("----------------------------------------")
    //
    //    for i in 1...10 {
    //      printState = 2
    //      numberOfActors = i
    //      useSelectionArray()
    //    }
    //    print("----------------------------------------")
    //
    //    for i in 1...10 {
    //      printState = 3
    //      numberOfGenres = i
    //      useSelectionArray()
    //    }
    //    print("----------------------------------------")
    //
    //    for i in 1...10 {
    //      printState = 4
    //      numberOfKeywords = i
    //      useSelectionArray()
    //    }
    //    print("----------------------------------------")
    //
//    printState = 5
    useSelectionArray()
    
  }
  
  
  
  
  func useSelectionArray() {
    
    let sampleSize = 30
    
    let numberOfYear = 2
    var numberOfDirectors = selectionArray.directors.count
    var numberOfActors = 20
    let numberOfGenres = 7
    var numberOfKeywords = 1
    
    var yearResults: [SearchResultFire] = []
    var directorsResults: [SearchResultFire] = []
    var actorsResults: [SearchResultFire] = []
    var genresResults: [SearchResultFire] = []
    var keywordsResults: [SearchResultFire] = []
    
    var yearsForSelection: [Int] = []
    var directorsForSelection: [String] = []
    var actorsForSelection: [String] = []
    var genresForSelection: [String] = []
    var keywordsForSelection: [String] = []
    
    let amountOfLibraryItems = libraryItems.count
    let printState = 5
    
    // Year
    for item in 0..<numberOfYear {
      for year in selectionArray.years[item].0 - 5...selectionArray.years[item].0 + 5 {
        var contain = false
        for yearInArray in yearsForSelection {
          if yearInArray == year {
            contain = true
          }
        }
        if !contain {
          yearsForSelection.append(year)
        }
      }
    }
    
    for film in wholeData {
      for year in yearsForSelection {
        if film.year == year {
          yearResults.append(film)
        }
      }
    }
    yearResults = excludeViewed(in: yearResults)
    //      print("Y:\(numberOfYear),\(yearResults.count)")
    
    // Directors
    while (directorsResults.count > sampleSize || directorsResults.count == 0) {
      directorsResults = []
      directorsForSelection = []
      for item in 0..<numberOfDirectors {
        directorsForSelection.append(selectionArray.directors[item].0)
      }
      
      for film in wholeData {
        for director in directorsForSelection {
          for filmDirector in film.directors ?? [] {
            if filmDirector == director {
              directorsResults.append(film)
            }
          }
        }
      }
      directorsResults = excludeViewed(in: directorsResults)
      directorsResults = crossResult(for: directorsResults, and: yearResults)
      //        print("D:\(numberOfDirectors),\(directorsResults.count)")
      
      numberOfDirectors -= 1
      if numberOfDirectors == 0 {
        break
      }
    }
    numberOfDirectors += 1
    
    
    
    // Actors
    while (actorsResults.count > sampleSize || actorsResults.count == 0) {
      actorsResults = []
      actorsForSelection = []
      for item in 0..<numberOfActors {
        actorsForSelection.append(selectionArray.actors[item].0)
      }
      
      for film in wholeData {
        for actor in actorsForSelection {
          for filmActor in film.actors ?? [] {
            if filmActor == actor {
              actorsResults.append(film)
            }
          }
        }
      }
      actorsResults = excludeViewed(in: actorsResults)
      actorsResults = crossResult(for: actorsResults, and: yearResults)
      //        print("A:\(numberOfActors),\(actorsResults.count)")
      
      numberOfActors -= 1
      if numberOfActors == 0 {
        break
      }
    }
    numberOfActors += 1
    
    
    
    
    // Genres
    
    //    while (genresResults.count > sampleSize || genresResults.count == 0) {
    
    //    genresResults = []
    //    genresForSelection = []
    
    for item in 0..<numberOfGenres {
      genresForSelection.append(selectionArray.genres[item].0)
    }
    
    for film in wholeData {
      var contain = true
      for filmGenre in film.genres{
        var localContain = false
        for genre in genresForSelection {
          if filmGenre == genre {
            localContain = true
          }
        }
        if !localContain {
          contain = false
        }
      }
      
      if contain {
        genresResults.append(film)
      }
    }
    
    genresResults = excludeViewed(in: genresResults)
    genresResults = crossResult(for: genresResults, and: yearResults)
    
    genresResults.sort { (first, second) -> Bool in
      Double(first.ratingKinopoisk) > Double(second.ratingKinopoisk)
    }
    genresResults.removeLast(genresResults.count - 30)
    //        print("G:\(numberOfGenres),\(genresResults.count)")
    
    //    numberOfGenres -= 1
    //    if numberOfGenres == 0 {
    //      numberOfGenres += 1
    //    }
    //    }
    
    
    
    // Keywords
    while (keywordsResults.count > sampleSize || keywordsResults.count == 0) {
      keywordsResults = []
      keywordsForSelection = []
      for item in 0..<numberOfKeywords {
        keywordsForSelection.append(selectionArray.keywords[item].0)
      }
      
      for film in wholeData {
        var contain = true
        for keyword in keywordsForSelection {
          var localContain = false
          for filmKeyword in film.keywords ?? [] {
            if filmKeyword == keyword {
              localContain = true
            }
          }
          if !localContain {
            contain = false
          }
        }
        if contain {
          keywordsResults.append(film)
        }
      }
      keywordsResults = excludeViewed(in: keywordsResults)
      keywordsResults = crossResult(for: keywordsResults, and: yearResults)
      //        print("K:\(numberOfKeywords),\(keywordsResults.count)")
      
      numberOfKeywords += 1
    }
    numberOfKeywords -= 1

    
    
    // Cross result
    
    //      var crossAG = crossResult(for: actorsResults, and: genresResults)
    //      var crossDA = crossResult(for: directorsResults, and: actorsResults)
    //      var crossDG = crossResult(for: directorsResults, and: genresResults)
    //
    //      var crossAGK = crossResult(for: actorsResults, and: genresResults)
    //      crossAGK = crossResult(for: crossAGK, and: keywordsResults)
    //      var crossDAGK = crossResult(for: crossAGK, and: directorsResults)
    
    finishArray = sumResult(for: actorsResults, and: genresResults)
    finishArray = sumResult(for: finishArray, and: keywordsResults)
    finishArray = sumResult(for: finishArray, and: directorsResults)
    
    
    // Print result
    switch printState {
    case 0:
      print("Y:\(numberOfYear),\(yearResults.count)")
    case 1:
      print("D:\(numberOfDirectors),\(directorsResults.count)")
    case 2:
      print("A:\(numberOfActors),\(actorsResults.count)")
    case 3:
      print("G:\(numberOfGenres),\(genresResults.count)")
    case 4:
      print("K:\(numberOfKeywords),\(keywordsResults.count)")
    case 5:
      print("---------------------------------------------------")
      print("Library items: \(amountOfLibraryItems)")
      print("Sample size: \(sampleSize)")
      print("Y:\(numberOfYear),\(yearResults.count)")
      print("D:\(numberOfDirectors),\(directorsResults.count)")
      print("A:\(numberOfActors),\(actorsResults.count)")
      print("G:\(numberOfGenres),\(genresResults.count)")
      print("K:\(numberOfKeywords),\(keywordsResults.count)")
      //        print("crossAG: \(crossAG.count)")
      //        print("crossDA: \(crossDA.count)")
      //        print("crossDG: \(crossDG.count)")
      //        print("crossAGK: \(crossAGK.count)")
      //        print("crossDAGK: \(crossDAGK.count)")
      print("Finish array: \(finishArray.count)")
      print("---------------------------------------------------")
    default:
      print("Invalid printState")
    }
    updateUI()
  }
  
  func sumResult(for filmArray1: [SearchResultFire], and filmArray2: [SearchResultFire]) -> [SearchResultFire] {
    var sumResultArray: [SearchResultFire] = []
    for film1 in filmArray1 {
      sumResultArray.append(film1)
    }
    for film2 in filmArray2 {
      sumResultArray.append(film2)
    }
    sumResultArray = excludeRepeat(in: sumResultArray)
    return sumResultArray
  }
  
  func crossResult(for filmArray1: [SearchResultFire], and filmArray2: [SearchResultFire]) -> [SearchResultFire] {
    var newArray: [SearchResultFire] = []
    for film1 in filmArray1 {
      for film2 in filmArray2 {
        if film1.key == film2.key {
          newArray.append(film1)
        }
      }
    }
    return newArray
  }
  
  func excludeViewed(in filmsArray: [SearchResultFire]) -> [SearchResultFire] {
    var itemsResult = filmsArray
    var numberOfFilmsForDelete: [Int] = []
    for numberOfFilm in 0..<itemsResult.count {
      for libraryItem in libraryItems {
        if itemsResult[numberOfFilm].key == libraryItem.key {
          numberOfFilmsForDelete.append(numberOfFilm)
        }
      }
    }
    var i = numberOfFilmsForDelete.count - 1
    while(i != -1) {
      itemsResult.remove(at: numberOfFilmsForDelete[i])
      i -= 1
    }
    
    itemsResult = excludeRepeat(in: itemsResult)
    return itemsResult
  }
  
  func excludeRepeat(in filmArray: [SearchResultFire]) -> [SearchResultFire] {
    var itemsResult = filmArray
    var keyArray: [Int] = []
    var keyForDelete: [Int] = []
    for film in 0..<itemsResult.count {
      var contain = false
      for key in keyArray {
        if key == Int(itemsResult[film].key) {
          contain = true
          keyForDelete.append(film)
        }
      }
      if !contain {
        keyArray.append(Int(itemsResult[film].key)!)
      }
    }
    
    var i = keyForDelete.count - 1
    while(i != -1) {
      itemsResult.remove(at: keyForDelete[i])
      i -= 1
    }
    return itemsResult
  }
  
  
  func makeSelectionArray() {
    for item in libraryItems {
      // Year
      var containYear = false
      for numberOfYear in 0..<selectionArray.years.count {
        if item.year == selectionArray.years[numberOfYear].0 {
          containYear = true
          selectionArray.years[numberOfYear].1 += 1
        }
      }
      if !containYear {
        selectionArray.years.append((item.year, 1))
      }
      // Directors
      for director in item.directors ?? []{
        var containDirector = false
        for numberOfDirector in 0..<selectionArray.directors.count {
          if director == selectionArray.directors[numberOfDirector].0 {
            containDirector = true
            selectionArray.directors[numberOfDirector].1 += 1
          }
        }
        if !containDirector {
          selectionArray.directors.append((director, 1))
        }
      }
      // Countries
      for country in item.countries {
        var containCountry = false
        for numberOfCountry in 0..<selectionArray.countries.count {
          if country == selectionArray.countries[numberOfCountry].0 {
            containCountry = true
            selectionArray.countries[numberOfCountry].1 += 1
          }
        }
        if !containCountry {
          selectionArray.countries.append((country, 1))
        }
      }
      // Actors
      for actor in item.actors ?? [] {
        var containActor = false
        for numberOfActor in 0..<selectionArray.actors.count {
          if actor == selectionArray.actors[numberOfActor].0 {
            containActor = true
            selectionArray.actors[numberOfActor].1 += 1
          }
        }
        if !containActor {
          selectionArray.actors.append((actor, 1))
        }
      }
      // Genres
      for genre in item.genres {
        var containGenre = false
        for numberOfGenre in 0..<selectionArray.genres.count {
          if genre == selectionArray.genres[numberOfGenre].0 {
            containGenre = true
            selectionArray.genres[numberOfGenre].1 += 1
          }
        }
        if !containGenre {
          selectionArray.genres.append((genre, 1))
        }
      }
      // Keywords
      for keyword in item.keywords ?? []{
        var containKeyword = false
        for numberOfKeyword in 0..<selectionArray.keywords.count {
          if keyword == selectionArray.keywords[numberOfKeyword].0 {
            containKeyword = true
            selectionArray.keywords[numberOfKeyword].1 += 1
          }
        }
        if !containKeyword {
          selectionArray.keywords.append((keyword, 1))
        }
      }
    }
    
    selectionArray.years.sort { (first, second) -> Bool in
      first.1 > second.1
    }
    selectionArray.directors.sort { (first, second) -> Bool in
      first.1 > second.1
    }
    selectionArray.countries.sort { (first, second) -> Bool in
      first.1 > second.1
    }
    selectionArray.actors.sort { (first, second) -> Bool in
      first.1 > second.1
    }
    selectionArray.genres.sort { (first, second) -> Bool in
      first.1 > second.1
    }
    selectionArray.keywords.sort { (first, second) -> Bool in
      first.1 > second.1
    }
    //    print(selectionArray)
    useSelectionArray()
//    controlSelection()
  }
  
  
  func downloadLibrary() {
    currentUserReference.observe(.value) { (snapshot) in
      var newItems: [SearchResultFire] = []
      for item in snapshot.children {
        let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
        newItems.append(searchItem)
      }
      self.libraryItems = newItems
      if self.mustLoad {
        self.mustLoad = false
        self.makeSelectionArray()
      }
    }
  }
  
  func downloadFilms() {
    var searchResultReference = Database.database().reference(withPath: "films")
    if testShot {
      searchResultReference = searchResultReference.child("100")
      searchResultReference.observe(.value) { (snapshot) in
        var newItems: [SearchResultFire] = []
        let searchItem = SearchResultFire(snapshot: snapshot)
        newItems.append(searchItem)
        self.wholeData = newItems
        self.downloadLibrary()
      }
    } else {
      searchResultReference.observe(.value) { (snapshot) in
        var newItems: [SearchResultFire] = []
        for item in snapshot.children {
          let searchItem = SearchResultFire(snapshot: item as! DataSnapshot)
          newItems.append(searchItem)
        }
        self.wholeData = newItems
        self.downloadLibrary()
      }
    }
    
  }
  
  
  func startLoading() {
    pleaseWaitLabel.text = "Мы подбираем для Вас фильм. Это может занять некоторое время. Пожалуйста подождите."
    loadingSpinner.startAnimating()
    
    let showLabel = true
    
    pleaseWaitLabel.isHidden = !showLabel
    loadingSpinner.isHidden = !showLabel
    
    artwork.isHidden = showLabel
    nameRu.isHidden = showLabel
    nameEnAndYear.isHidden = showLabel
    genres.isHidden = showLabel
    countriesAndDuration.isHidden = showLabel
    tagline.isHidden = showLabel
    ageAndMpaa.isHidden = showLabel
    ratingKinopoisk.isHidden = showLabel
    filmDescription.isHidden = showLabel
    directorsLabel.isHidden = showLabel
    producersLabel.isHidden = showLabel
    actorsLabel.isHidden = showLabel
    yesButton.isHidden = showLabel
    noButton.isHidden = showLabel
    refreshButton.isHidden = showLabel
    
    titleActors.isHidden = showLabel
    titleRatingKP.isHidden = showLabel
    titleDirectors.isHidden = showLabel
    titleProducers.isHidden = showLabel
    grayView.isHidden = showLabel
        
    if !firstTime {
      makeSelectionArray()
    }
    
  }
  
  func updateUI() {
    if artwork.isHidden {
      let showLabel = false
      
      pleaseWaitLabel.isHidden = !showLabel
      loadingSpinner.isHidden = !showLabel
      
      artwork.isHidden = showLabel
      nameRu.isHidden = showLabel
      nameEnAndYear.isHidden = showLabel
      genres.isHidden = showLabel
      countriesAndDuration.isHidden = showLabel
      tagline.isHidden = showLabel
      ageAndMpaa.isHidden = showLabel
      ratingKinopoisk.isHidden = showLabel
      filmDescription.isHidden = showLabel
      directorsLabel.isHidden = showLabel
      producersLabel.isHidden = showLabel
      actorsLabel.isHidden = showLabel
      yesButton.isHidden = showLabel
      noButton.isHidden = showLabel
      refreshButton.isHidden = showLabel
      
      titleActors.isHidden = showLabel
      titleRatingKP.isHidden = showLabel
      titleDirectors.isHidden = showLabel
      titleProducers.isHidden = showLabel
      grayView.isHidden = showLabel
    }
    
    filmNumber += 1
    if filmNumber == finishArray.count{
      filmNumber = -1
      startLoading()
    } else {
      let searchItem = finishArray[filmNumber]
      
      nameRu.text = searchItem.nameRu
      if let nameEn = searchItem.nameEn  {
        nameEnAndYear.text = nameEn + "(" + String(searchItem.year) + ")"
      } else {
        nameEnAndYear.text = "(" + String(searchItem.year) + ")"
      }
      var temporaryString = ""
      genres.text = fillString(searchItem.genres)
      temporaryString = ""
      for country in searchItem.countries {temporaryString += country + ", "}
      countriesAndDuration.text = temporaryString + searchItem.getDuration()
      tagline.text = searchItem.tagline
      temporaryString = ""
      temporaryString += String(searchItem.ratingMpaa ?? "") + "   " + String(searchItem.ageLimit ?? 0) + "+"
      ageAndMpaa.text = temporaryString
      ratingKinopoisk.text = String(round(Double(truncating: searchItem.ratingKinopoisk) * 10)/10)
      filmDescription.text = searchItem.description
      if let directors = searchItem.directors {
        directorsLabel.text = fillString(directors)
      } else {
        directorsLabel.text = "Неизвестно"
      }
      if let producers = searchItem.producers {
        producersLabel.text = fillString(producers)
      } else {
        producersLabel.text = "Неизвестно"
      }
      if let actors = searchItem.actors {
        actorsLabel.text = fillString(actors)
      } else {
        actorsLabel.text = "Неизвестно"
      }
      if let largeURL = URL(string: searchItem.imageUrl) {
        downloadTask = artwork.loadImage(url: largeURL)
      }
    }
  }
  
  func fillString(_ items: [String]) -> String {
    var temporaryString = ""
    var countOfItems = items.count
    for item in items {
      if countOfItems == 1 {
        temporaryString += item
      } else {
        temporaryString += item + ", "
      }
      countOfItems -= 1
    }
    return temporaryString
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func noButton(_ sender: Any) {
    finishArray[filmNumber].opinion = false
    if let opinion = finishArray[filmNumber].opinion {
      recordItem(opinion: opinion)
    } else {
      print("Opinion is nil.")
    }
    updateUI()
  }
  
  @IBAction func refresh(_ sender: Any) {
    updateUI()
  }
  @IBAction func yesButton(_ sender: Any) {
    let alert = UIAlertController(title: "Отлично!",
                                  message: "Ваш фильм на сегодня: \(wholeData[0].nameRu) (\(wholeData[0].year)), \(wholeData[0].nameEn ?? "").\nНе забудте оцень фильм после проссмотра. " ,
      preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Спасибо", style: .default) { actoin in
      self.dismiss(animated: true, completion: nil)
    })
    present(alert, animated: true, completion: nil)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.default
  }
  
  func recordItem(opinion: Bool) {
    let itemForRecord = finishArray[filmNumber]
    let libraryItemReference = currentUserReference.child(itemForRecord.key)
    let values: [String: Any] = ["nameRu": itemForRecord.nameRu,
                                 "nameEn": itemForRecord.nameEn ?? "",
                                 "imageUrl": itemForRecord.imageUrl,
                                 "year": itemForRecord.year,
                                 "countries": itemForRecord.countries,
                                 "tagline": itemForRecord.tagline,
                                 "directors": itemForRecord.directors ?? [],
                                 "producers": itemForRecord.producers ?? [],
                                 "genres": itemForRecord.genres,
                                 "budget": itemForRecord.budget ?? "",
                                 "ageLimit": itemForRecord.ageLimit ?? 0,
                                 "ratingKinopoisk": itemForRecord.ratingKinopoisk,
                                 "ratingMpaa": itemForRecord.ratingMpaa ?? "",
                                 "duration": itemForRecord.duration,
                                 "actors": itemForRecord.actors ?? [],
                                 "description": itemForRecord.description,
                                 "keywords": itemForRecord.keywords ?? [],
                                 "opinion": itemForRecord.opinion ?? true]
    libraryItemReference.setValue(values)
  }
  
}
