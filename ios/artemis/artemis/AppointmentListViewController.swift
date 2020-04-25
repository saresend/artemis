//
//  AppointmentListViewController.swift
//  artemis
//
//  Created by Samuel Resendez on 4/25/20.
//  Copyright © 2020 Samuel Resendez. All rights reserved.
//

import UIKit

class Appointment {
    var title: String = ""
    var date: Date = Date()
    var ident: String = "yeeehaw"
    
    init(title: String, date: Date, ident: String) {
        self.title = title
        self.date = date
        self.ident = ident
    }
}

class AppointmentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var appointments = [ Appointment(title: "Trader Joes", date: Date() + 250000, ident: "asdfasdf"),
                         Appointment(title: "CVS", date: Date() + 500000, ident: "yeeehaw"),
    Appointment(title: "Walmart", date: Date() + 1000000, ident: "oh buddy")]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointCell") as! AppointmentTableViewCell
        cell.titleLabel.text = appointments[indexPath.row].title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        cell.dateLabel.text = formatter.string(from:appointments[indexPath.row].date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    @IBOutlet var appointmentTableView: UITableView!
    
    override func viewDidLoad() {
        appointmentTableView.delegate = self
        appointmentTableView.dataSource = self
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func deleteRow(_ sender: UIButton) {
        guard let cell =  sender.superview?.superview as? AppointmentTableViewCell  else {
            return
        }
        let indexPath = appointmentTableView.indexPath(for: cell)
        appointments.remove(at: indexPath!.row)
        appointmentTableView.reloadData()
        print(indexPath)
    }
    
}
