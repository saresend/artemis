//
//  SchedulingViewController.swift
//  artemis
//
//  Created by Samuel Resendez on 4/25/20.
//  Copyright © 2020 Samuel Resendez. All rights reserved.
//

import UIKit
import JTAppleCalendar

class SchedulingViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet var calendarView: JTACMonthView!
    var date: Date?
    @IBOutlet var backgroundView: UIView!
    var locationID = 0 // Should be set by segue
    var locationName = "" // SHould be set by seguee
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        print("HERE IS LOCATION ID")
        print(locationID)
        backgroundView.layer.cornerRadius = 40
        backgroundView.backgroundColor = ThemeBlue
        calendarView.backgroundColor = UIColor.clear
        locationLabel.text = locationName
        locationLabel.textColor = ThemeOrange
        cancelButton.tintColor = ThemeOrange
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SchedulingViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = Date()
        let endDate = Date() + 268000.0
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension SchedulingViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        if let dateCell = cell as? DateCell {
            dateCell.dateLabel.textColor = UIColor.black
        }
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        cell.dateLabel.text = cellState.text
        cell.dateLabel.textColor = UIColor.white
        if cellState.dateBelongsTo != .thisMonth {
            cell.isHidden = true
        }
        if date.timeIntervalSinceNow < 0 {
            cell.dateLabel.textColor = UIColor.lightGray
        }
        if Calendar.current.isDateInToday(date) {
            cell.dateLabel.textColor = ThemeOrange
        }
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is TimeViewController
        {
            let vc = segue.destination as? TimeViewController
            vc?.date = self.date
            vc?.locationID = locationID
        }
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        print(date)
        self.date = date
        performSegue(withIdentifier: "toTime", sender: nil)
    }
}


