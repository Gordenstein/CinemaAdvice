//
//  MovieFiltersViewController.swift
//  CinemaAdvice
//
//  Created by Hero on 13.05.2018.
//  Copyright © 2018 Eugene Gordenstein. All rights reserved.
//

import UIKit

protocol MovieFiltersViewControllerDelegate: class {
  func finishEditingFilters(_ controller: MovieFiltersViewController, newFilters: Filters)
}

// swiftlint:disable:next type_body_length
class MovieFiltersViewController: UITableViewController,
                                  UIPickerViewDataSource,
                                  UIPickerViewDelegate,
                                  MovieGenresViewControllerDelegate {
  // MARK: Genres View Controller Delegate
  func finishEditingGenres(_ controller: MovieGenresViewController, newFilters: Filters) {
    filters = newFilters
  }

  // MARK: Start
  var filters = Filters()
  var changeFilters = false
  var yearPickerVisible = false
  var whoOpenYear: IndexPath?
  let startYearIndex = IndexPath(row: 0, section: 1)
  var agePickerVisible = false
  var whoOpenAge: IndexPath?
  let startAgeIndex = IndexPath(row: 0, section: 2)
  weak var delegate: MovieFiltersViewControllerDelegate?
  var valuesForYearPicker: [Int] = []
  let valuesForAgePicker = ["0+", "6+", "12+", "16+", "18+"]

  var openingGenres = false

  @IBOutlet weak var yearPickerCell: UITableViewCell!
  @IBOutlet weak var yearPicker: UIPickerView!
  @IBOutlet weak var agePickerCell: UITableViewCell!
  @IBOutlet weak var agePicker: UIPickerView!
  @IBOutlet weak var startYearLabel: UILabel!
  @IBOutlet weak var endYearLabel: UILabel!
  @IBOutlet weak var startAgeLabel: UILabel!
  @IBOutlet weak var endAgeLabel: UILabel!
  @IBOutlet weak var resetBarButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()
    buildValuesForYearPicker()
    setDelegates()
    updateLabelsAccordingToFilters()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewWillAppear(_ animated: Bool) {
    updateResetButtonVisibility()
    super.viewWillAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    // Workaround for system Back button 
    if !openingGenres {
      delegate?.finishEditingFilters(self, newFilters: filters)
    }
    openingGenres.toggle()
    super.viewWillDisappear(animated)
  }

  @IBAction func resetBarButtonPressed(_ sender: Any) {
    hideYearPicker()
    hideAgePicker()
    self.filters = Filters()
    updateLabelsAccordingToFilters()
    resetBarButton.isEnabled = false
  }

  func setDelegates() {
    yearPicker.delegate = self
    yearPicker.dataSource = self
    agePicker.delegate = self
    agePicker.dataSource = self
  }

  func updateLabelsAccordingToFilters() {
    startYearLabel.text = String(filters.startYear)
    endYearLabel.text = String(filters.endYear)
    startAgeLabel.text = valuesForAgePicker[filters.startAge]
    endAgeLabel.text = valuesForAgePicker[filters.endAge]
  }

  func buildValuesForYearPicker() {
    for year in 1939...2018 {
      valuesForYearPicker.append(year)
    }
  }

  func updateResetButtonVisibility() {
    if !filters.isDefault() {
      resetBarButton.isEnabled = true
    } else {
      resetBarButton.isEnabled = false
    }
  }

  // MARK: - Picker views methoods and data source
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == yearPicker {
      return valuesForYearPicker.count
    } else {
      return valuesForAgePicker.count
    }
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == yearPicker {
      return String(valuesForYearPicker[row])
    } else {
      return String(valuesForAgePicker[row])
    }
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == yearPicker {
      setYear(pickerView, didSelectRow: row)
    } else {
      setAge(pickerView, didSelectRow: row)
    }
    updateResetButtonVisibility()
  }

  func setYear(_ pickerView: UIPickerView, didSelectRow row: Int) {
    if whoOpenYear == startYearIndex {
      let endYear = filters.endYear-1939
      if row > endYear {
        pickerView.selectRow(endYear, inComponent: 0, animated: true)
        filters.startYear = valuesForYearPicker[endYear]
        startYearLabel.text = String(valuesForYearPicker[endYear])
      } else {
        filters.startYear = valuesForYearPicker[row]
        startYearLabel.text = String(valuesForYearPicker[row])
      }
    } else {
      let startYear = filters.startYear-1939
      if row < startYear {
        pickerView.selectRow(startYear, inComponent: 0, animated: true)
        filters.endYear = valuesForYearPicker[startYear]
        endYearLabel.text = String(valuesForYearPicker[startYear])
      } else {
        filters.endYear = valuesForYearPicker[row]
        endYearLabel.text = String(valuesForYearPicker[row])
      }
    }
  }

  func setAge(_ pickerView: UIPickerView, didSelectRow row: Int) {
    if whoOpenAge == startAgeIndex {
      let endAge = filters.endAge
      if row > endAge {
        pickerView.selectRow(endAge, inComponent: 0, animated: true)
        filters.startAge = endAge
        startAgeLabel.text = valuesForAgePicker[endAge]
      } else {
        filters.startAge = row
        startAgeLabel.text = valuesForAgePicker[row]
      }
    } else {
      let startAge = filters.startAge
      if row < startAge {
        pickerView.selectRow(startAge, inComponent: 0, animated: true)
        filters.endAge = startAge
        endAgeLabel.text = valuesForAgePicker[startAge]
      } else {
        filters.endAge = row
        endAgeLabel.text = valuesForAgePicker[row]
      }
    }
  }

  func showYearPicker(opener: IndexPath) {
    yearPickerVisible = true
    whoOpenYear = opener
    let indexPathYearRow = whoOpenYear!
    let indexPathYearPicker = IndexPath(row: 2, section: 1)
    tableView.beginUpdates()
    tableView.insertRows(at: [indexPathYearPicker], with: .fade)
    tableView.reloadRows(at: [indexPathYearRow], with: .none)
    tableView.endUpdates()
    if whoOpenYear == startYearIndex {
      yearPicker.selectRow(filters.startYear-1939, inComponent: 0, animated: false)
    } else {
      yearPicker.selectRow(filters.endYear-1939, inComponent: 0, animated: false)
    }
  }

  func hideYearPicker() {
    if yearPickerVisible {
      yearPickerVisible = false
      let indexPathYearRow = whoOpenYear!
      let indexPathYearPicker = IndexPath(row: 2, section: 1)
      whoOpenYear = nil
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPathYearRow], with: .none)
      tableView.deleteRows(at: [indexPathYearPicker], with: .fade)
      tableView.endUpdates()
    }
  }

  func showAgePicker(opener: IndexPath) {
    agePickerVisible = true
    whoOpenAge = opener
    let indexPathAgeRow = whoOpenAge!
    let indexPathAgePicker = IndexPath(row: 2, section: 2)
    tableView.beginUpdates()
    tableView.insertRows(at: [indexPathAgePicker], with: .fade)
    tableView.reloadRows(at: [indexPathAgeRow], with: .none)
    tableView.endUpdates()
    if whoOpenAge == startAgeIndex {
      agePicker.selectRow(filters.startAge, inComponent: 0, animated: false)
    } else {
      agePicker.selectRow(filters.endAge, inComponent: 0, animated: false)
    }
  }

  func hideAgePicker() {
    if agePickerVisible {
      agePickerVisible = false
      let indexPathAgeRow = whoOpenAge!
      let indexPathAgePicker = IndexPath(row: 2, section: 2)
      whoOpenAge = nil
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPathAgeRow], with: .none)
      tableView.deleteRows(at: [indexPathAgePicker], with: .fade)
      tableView.endUpdates()
    }
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 && yearPickerVisible {
      return 3
    } else if section == 2 && agePickerVisible {
      return 3
    } else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    switch indexPath.section {
    case 1:
      if agePickerVisible {
        hideAgePicker()
      }
      if !yearPickerVisible {
        showYearPicker(opener: indexPath)
      } else if indexPath == whoOpenYear {
        hideYearPicker()
      } else {
        hideYearPicker()
        showYearPicker(opener: indexPath)
      }
    case 2:
      if yearPickerVisible {
        hideYearPicker()
      }
      if !agePickerVisible {
        showAgePicker(opener: indexPath)
      } else if indexPath == whoOpenAge {
        hideAgePicker()
      } else {
        hideAgePicker()
        showAgePicker(opener: indexPath)
      }
    default:
      print("")
    }

  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 && indexPath.row == 2 {
      return yearPickerCell
    } else if indexPath.section == 2 && indexPath.row == 2 {
      return agePickerCell
    } else {
      return super.tableView(tableView, cellForRowAt: indexPath)
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if (indexPath.section == 1 && indexPath.row == 2) || (indexPath.section == 2 && indexPath.row == 2) {
      return 163
    } else {
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }

  override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
    var newIndexPath = indexPath
    if (indexPath.section == 1 && indexPath.row == 2) || (indexPath.section == 2 && indexPath.row == 2) {
      newIndexPath = IndexPath(row: 0, section: indexPath.section)
    }
    return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.showGenresSegueID,
       let genresViewController = segue.destination as? MovieGenresViewController {
      openingGenres = true
      genresViewController.filters = filters
      genresViewController.delegate = self
    }
  }
}
