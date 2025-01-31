//
//  AlgorithmResultViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 21.04.2018.
//  Copyright © 2018 Eugene Gordenstein. All rights reserved.
//

import UIKit
import Firebase

// swiftlint:disable:next type_body_length
class AlgorithmResultViewController: UIViewController {

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
  @IBOutlet weak var chooseButton: UIButton!
  @IBOutlet weak var yesButton: UIButton!

  var libraryItems: [Movie] = []
  var wholeData: [Movie] = []
  var finishArray: [Movie] = []
  var filmNumber = -1
  var downloadTask: URLSessionDownloadTask?
  let libraryReference = Database.database().reference(withPath: Constants.usersFavoriteFilmsPath)
  var currentUserReference = Database.database().reference()
  var selectionArray = MainAlgorithmRecomendations()
  var mustLoad = true
  var firstTime = true

  override func viewDidLoad() {
    super.viewDidLoad()

    refreshButton.layer.cornerRadius = 5
    noButton.layer.cornerRadius = 5
    yesButton.layer.cornerRadius = 5
    chooseButton.layer.cornerRadius = 5
    startLoading()

    let userDefaults = UserDefaults.standard
    if let userFavoriteFilmsPath = userDefaults.object(forKey: Constants.userFavoriteFilmsPathKey) as? String {
      self.currentUserReference = self.libraryReference.child(userFavoriteFilmsPath)
      if self.firstTime {
        self.firstTime = false
        self.downloadFilms()
      }
    } else {
      // Error - Log out
    }
  }

  let printState = 5

  func useSelectionArray() {

    let sampleSize = 30

    let numberOfYear = 2
    let numberOfDirectors = selectionArray.directors.count
    let numberOfActors = 20
    let numberOfGenres = 7
    let numberOfKeywords = 1

    let yearResults = getResultAccordingToYear(numberOfYear: numberOfYear)
    let directorsResults = getResultAccordingToDirectors(amountOfDirectors: numberOfDirectors,
                                                         sampleSize: sampleSize,
                                                         yearResults: yearResults)
    let actorsResults = getResultAccordingToActors(amountOfActors: numberOfActors,
                                                   sampleSize: sampleSize,
                                                   yearResults: yearResults)
    let genresResults = getResultAccordingToGenres(numberOfGenres: numberOfGenres,
                                                   yearResults: yearResults)
    let keywordsResults = getResultAccordingToKeywords(amountOfKeywords: numberOfKeywords,
                                                       sampleSize: sampleSize,
                                                       yearResults: yearResults)

    // Cross result
    finishArray = sumResult(for: actorsResults, and: genresResults)
    finishArray = sumResult(for: finishArray, and: keywordsResults)
    finishArray = sumResult(for: finishArray, and: directorsResults)

    // Print result
    //    let amountOfLibraryItems = libraryItems.count
    //    switch printState {
    //    case 0:
    //      print("Y:\(numberOfYear),\(yearResults.count)")
    //    case 1:
    //      print("D:\(numberOfDirectors),\(directorsResults.count)")
    //    case 2:
    //      print("A:\(numberOfActors),\(actorsResults.count)")
    //    case 3:
    //      print("G:\(numberOfGenres),\(genresResults.count)")
    //    case 4:
    //      print("K:\(numberOfKeywords),\(keywordsResults.count)")
    //    case 5:
    //      print("---------------------------------------------------")
    //      print("Library items: \(amountOfLibraryItems)")
    //      print("Sample size: \(sampleSize)")
    //      print("Y:\(numberOfYear),\(yearResults.count)")
    //      print("D:\(numberOfDirectors),\(directorsResults.count)")
    //      print("A:\(numberOfActors),\(actorsResults.count)")
    //      print("G:\(numberOfGenres),\(genresResults.count)")
    //      print("K:\(numberOfKeywords),\(keywordsResults.count)")
    //      print("Finish array: \(finishArray.count)")
    //      print("---------------------------------------------------")
    //    default:
    //      print("Invalid printState")
    //    }
    updateUI()
  }

  func getResultAccordingToYear(numberOfYear: Int) -> [Movie] {
    var yearsForSelection: [Int] = []
    var yearResults: [Movie] = []
    // Year
    for item in 0..<numberOfYear {
      for year in selectionArray.years[item].0 - 5...selectionArray.years[item].0 + 5 {
        var contain = false
        for yearInArray in yearsForSelection where yearInArray == year {
          contain = true
        }
        if !contain {
          yearsForSelection.append(year)
        }
      }
    }

    for film in wholeData {
      for year in yearsForSelection where film.year == year {
        yearResults.append(film)
      }
    }
    //    print("Y:\(numberOfYear),\(yearResults.count)")
    return excludeViewed(in: yearResults)
  }

  func getResultAccordingToDirectors(amountOfDirectors: Int,
                                     sampleSize: Int,
                                     yearResults: [Movie]) -> [Movie] {
    var numberOfDirectors = amountOfDirectors
    var directorsResults: [Movie] = []
    var directorsForSelection: [String] = []
    // Directors
    while directorsResults.count > sampleSize || directorsResults.count == 0 {
      directorsResults = []
      directorsForSelection = []
      for item in 0..<numberOfDirectors {
        directorsForSelection.append(selectionArray.directors[item].0)
      }

      for film in wholeData {
        for director in directorsForSelection {
          for filmDirector in film.directors ?? [] where filmDirector == director {
            directorsResults.append(film)
          }
        }
      }
      directorsResults = excludeViewed(in: directorsResults)
      directorsResults = crossResult(for: directorsResults, and: yearResults)
      //      print("D:\(numberOfDirectors),\(directorsResults.count)")
      numberOfDirectors -= 1
      if numberOfDirectors == 0 {
        break
      }
    }
    numberOfDirectors += 1
    return directorsResults
  }

  func getResultAccordingToActors(amountOfActors: Int,
                                  sampleSize: Int,
                                  yearResults: [Movie]) -> [Movie] {
    var numberOfActors = amountOfActors
    var actorsResults: [Movie] = []
    var actorsForSelection: [String] = []
    // Actors
    while actorsResults.count > sampleSize || actorsResults.count == 0 {
      actorsResults = []
      actorsForSelection = []
      for item in 0..<numberOfActors {
        actorsForSelection.append(selectionArray.actors[item].0)
      }

      for film in wholeData {
        for actor in actorsForSelection {
          for filmActor in film.actors ?? [] where filmActor == actor {
            actorsResults.append(film)
          }
        }
      }
      actorsResults = excludeViewed(in: actorsResults)
      actorsResults = crossResult(for: actorsResults, and: yearResults)
      //      print("A:\(numberOfActors),\(actorsResults.count)")
      numberOfActors -= 1
      if numberOfActors == 0 {
        break
      }
    }
    numberOfActors += 1
    return actorsResults
  }

  func getResultAccordingToGenres(numberOfGenres: Int,
                                  yearResults: [Movie]) -> [Movie] {
    var genresResults: [Movie] = []
    var genresForSelection: [String] = []
    // Genres
    for item in 0..<numberOfGenres {
      genresForSelection.append(selectionArray.genres[item].0)
    }

    for film in wholeData {
      var contain = true
      for filmGenre in film.genres {
        var localContain = false
        for genre in genresForSelection where filmGenre == genre {
          localContain = true
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
      Double(truncating: first.ratingKinopoisk) > Double(truncating: second.ratingKinopoisk)
    }
    genresResults.removeLast(genresResults.count - 30)
    //    print("G:\(numberOfGenres),\(genresResults.count)")
    return genresResults
  }

  func getResultAccordingToKeywords(amountOfKeywords: Int,
                                    sampleSize: Int,
                                    yearResults: [Movie]) -> [Movie] {
    var numberOfKeywords = amountOfKeywords
    var keywordsResults: [Movie] = []
    var keywordsForSelection: [String] = []
    // Keywords
    while keywordsResults.count > sampleSize || keywordsResults.count == 0 {
      keywordsResults = []
      keywordsForSelection = []
      for item in 0..<numberOfKeywords {
        keywordsForSelection.append(selectionArray.keywords[item].0)
      }

      for film in wholeData {
        var contain = true
        for keyword in keywordsForSelection {
          var localContain = false
          for filmKeyword in film.keywords ?? [] where filmKeyword == keyword {
            localContain = true
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
    return keywordsResults
  }

  func sumResult(for filmArray1: [Movie], and filmArray2: [Movie]) -> [Movie] {
    var sumResultArray: [Movie] = []
    for film1 in filmArray1 {
      sumResultArray.append(film1)
    }
    for film2 in filmArray2 {
      sumResultArray.append(film2)
    }
    sumResultArray = excludeRepeat(in: sumResultArray)
    return sumResultArray
  }

  func crossResult(for filmArray1: [Movie], and filmArray2: [Movie]) -> [Movie] {
    var newArray: [Movie] = []
    for film1 in filmArray1 {
      for film2 in filmArray2 where film1.key == film2.key {
        newArray.append(film1)
      }
    }
    return newArray
  }

  func excludeViewed(in filmsArray: [Movie]) -> [Movie] {
    var itemsResult = filmsArray
    var numberOfFilmsForDelete: [Int] = []
    for numberOfFilm in 0..<itemsResult.count {
      for libraryItem in libraryItems where itemsResult[numberOfFilm].key == libraryItem.key {
        numberOfFilmsForDelete.append(numberOfFilm)
      }
    }
    var index = numberOfFilmsForDelete.count - 1
    while index != -1 {
      itemsResult.remove(at: numberOfFilmsForDelete[index])
      index -= 1
    }

    itemsResult = excludeRepeat(in: itemsResult)
    return itemsResult
  }

  func excludeRepeat(in filmArray: [Movie]) -> [Movie] {
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

    var index = keyForDelete.count - 1
    while index != -1 {
      itemsResult.remove(at: keyForDelete[index])
      index -= 1
    }
    return itemsResult
  }

  // swiftlint:disable:next cyclomatic_complexity function_body_length
  func makeSelectionArray() {
    for item in libraryItems {
      // Year
      var containYear = false
      for numberOfYear in 0..<selectionArray.years.count where item.year == selectionArray.years[numberOfYear].0 {
        containYear = true
        if item.opinion ?? true {
          selectionArray.years[numberOfYear].1 += 1
        } else {
          selectionArray.years[numberOfYear].1 -= 1
        }
      }
      if !containYear {
        if item.opinion ?? true {
          selectionArray.years.append((item.year, 1))
        } else {
          selectionArray.years.append((item.year, -1))
        }
      }
      // Directors
      for director in item.directors ?? [] {
        var containDirector = false
        for numberOfDirector in 0..<selectionArray.directors.count where
          director == selectionArray.directors[numberOfDirector].0 {
          containDirector = true
          if item.opinion ?? true {
            selectionArray.directors[numberOfDirector].1 += 1
          } else {
            selectionArray.directors[numberOfDirector].1 -= 1
          }
        }
        if !containDirector {
          if item.opinion ?? true {
            selectionArray.directors.append((director, 1))
          } else {
            selectionArray.directors.append((director, -1))
          }
        }
      }
      // Countries
      for country in item.countries {
        var containCountry = false
        for numberOfCountry in 0..<selectionArray.countries.count where
          country == selectionArray.countries[numberOfCountry].0 {
          containCountry = true
          if item.opinion ?? true {
            selectionArray.countries[numberOfCountry].1 += 1
          } else {
            selectionArray.countries[numberOfCountry].1 -= 1
          }
        }
        if !containCountry {
          if item.opinion ?? true {
            selectionArray.countries.append((country, 1))
          } else {
            selectionArray.countries.append((country, -1))
          }
        }
      }
      // Actors
      for actor in item.actors ?? [] {
        var containActor = false
        for numberOfActor in 0..<selectionArray.actors.count where actor == selectionArray.actors[numberOfActor].0 {
          containActor = true
          if item.opinion ?? true {
            selectionArray.actors[numberOfActor].1 += 1
          } else {
            selectionArray.actors[numberOfActor].1 -= 1
          }
        }
        if !containActor {
          if item.opinion ?? true {
            selectionArray.actors.append((actor, 1))
          } else {
            selectionArray.actors.append((actor, -1))
          }
        }
      }
      // Genres
      for genre in item.genres {
        var containGenre = false
        for numberOfGenre in 0..<selectionArray.genres.count where genre == selectionArray.genres[numberOfGenre].0 {
          containGenre = true
          if item.opinion ?? true {
            selectionArray.genres[numberOfGenre].1 += 1
          } else {
            selectionArray.genres[numberOfGenre].1 -= 1
          }
        }
        if !containGenre {
          if item.opinion ?? true {
            selectionArray.genres.append((genre, 1))
          } else {
            selectionArray.genres.append((genre, -1))
          }
        }
      }
      // Keywords
      for keyword in item.keywords ?? [] {
        var containKeyword = false
        for numberOfKeyword in 0..<selectionArray.keywords.count where
          keyword == selectionArray.keywords[numberOfKeyword].0 {
          containKeyword = true
          if item.opinion ?? true {
            selectionArray.keywords[numberOfKeyword].1 += 1
          } else {
            selectionArray.keywords[numberOfKeyword].1 -= 1
          }
        }
        if !containKeyword {
          if item.opinion ?? true {
            selectionArray.keywords.append((keyword, 1))
          } else {
            selectionArray.keywords.append((keyword, -1))
          }
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
    print(selectionArray)
    useSelectionArray()
  }

  func downloadLibrary() {
    currentUserReference.observe(.value) { (snapshot) in
      var newItems: [Movie] = []
      for item in snapshot.children {
        if let snapshot = item as? DataSnapshot {
          let searchItem = Movie(snapshot: snapshot)
          newItems.append(searchItem)
        }
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
    if Constants.loadOneFilmFromDB {
      searchResultReference = searchResultReference.child("100")
      searchResultReference.observe(.value) { (snapshot) in
        var newItems: [Movie] = []
        let searchItem = Movie(snapshot: snapshot)
        newItems.append(searchItem)
        self.wholeData = newItems
        self.downloadLibrary()
      }
    } else {
      searchResultReference.observe(.value) { (snapshot) in
        var newItems: [Movie] = []
        for item in snapshot.children {
          if let snapshot = item as? DataSnapshot {
            let searchItem = Movie(snapshot: snapshot)
            newItems.append(searchItem)
          }
        }
        self.wholeData = newItems
        self.downloadLibrary()
      }
    }

  }

  func startLoading() {
    pleaseWaitLabel.text = NSLocalizedString(
      "We are selecting a film for you. This may take some time. Please wait.",
      comment: "Мы подбираем для Вас фильм. Это может занять некоторое время. Пожалуйста подождите.")
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
    chooseButton.isHidden = showLabel
    noButton.isHidden = showLabel
    yesButton.isHidden = showLabel
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

  // swiftlint:disable:next function_body_length
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
      chooseButton.isHidden = showLabel
      noButton.isHidden = showLabel
      yesButton.isHidden = showLabel
      refreshButton.isHidden = showLabel

      titleActors.isHidden = showLabel
      titleRatingKP.isHidden = showLabel
      titleDirectors.isHidden = showLabel
      titleProducers.isHidden = showLabel
      grayView.isHidden = showLabel
    }

    filmNumber += 1
    if filmNumber == finishArray.count {
      filmNumber = -1
      startLoading()
    } else {
      let searchItem = finishArray[filmNumber]

      nameRu.text = searchItem.nameRu
      if let nameEn = searchItem.nameEn {
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
      let unkownString = NSLocalizedString(
        "Unknown",
        comment: "Неизвестно")
      if let directors = searchItem.directors {
        directorsLabel.text = fillString(directors)
      } else {
        directorsLabel.text = unkownString
      }
      if let producers = searchItem.producers {
        producersLabel.text = fillString(producers)
      } else {
        producersLabel.text = unkownString
      }
      if let actors = searchItem.actors {
        actorsLabel.text = fillString(actors)
      } else {
        actorsLabel.text = unkownString
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

  @IBAction func yesButton(_ sender: Any) {
    finishArray[filmNumber].opinion = true
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

  @IBAction func chooseButton(_ sender: Any) {
    let nameRu = finishArray[filmNumber].nameRu
    let year = finishArray[filmNumber].year
    let nameEn = finishArray[filmNumber].nameEn ?? ""
    let alertTitle = NSLocalizedString("Amazing!", comment: "Отлично!")
    let alertMessagePrefix = NSLocalizedString("Your film: ", comment: "Ваш фильм на сегодня: ")
    let alertMessagePostfix = NSLocalizedString(
      "Feel free to rate this title after watching", comment: "Не забудьте оценить фильм после просмотра")
    let alertActionMessage = NSLocalizedString("Thanks", comment: "Спасибо")
    let alert = UIAlertController(
      title: alertTitle,
      message: alertMessagePrefix + "\(nameRu) (\(year)), \(nameEn).\n" + alertMessagePostfix,
      preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: alertActionMessage, style: .default) { _ in
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
    let values: [String: Any] = [Constants.nameRu: itemForRecord.nameRu,
                                 Constants.nameEn: itemForRecord.nameEn ?? "",
                                 Constants.imageUrl: itemForRecord.imageUrl,
                                 Constants.year: itemForRecord.year,
                                 Constants.countries: itemForRecord.countries,
                                 Constants.tagline: itemForRecord.tagline,
                                 Constants.directors: itemForRecord.directors ?? [],
                                 Constants.producers: itemForRecord.producers ?? [],
                                 Constants.genres: itemForRecord.genres,
                                 Constants.budget: itemForRecord.budget ?? "",
                                 Constants.ageLimit: itemForRecord.ageLimit ?? 0,
                                 Constants.ratingKinopoisk: itemForRecord.ratingKinopoisk,
                                 Constants.ratingMpaa: itemForRecord.ratingMpaa ?? "",
                                 Constants.duration: itemForRecord.duration,
                                 Constants.actors: itemForRecord.actors ?? [],
                                 Constants.description: itemForRecord.description,
                                 Constants.keywords: itemForRecord.keywords ?? [],
                                 Constants.opinion: itemForRecord.opinion ?? true]
    libraryItemReference.setValue(values)
  }
  // swiftlint:disable:next file_length
}
