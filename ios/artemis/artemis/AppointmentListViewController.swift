//
//  AppointmentListViewController.swift
//  artemis
//
//  Created by Samuel Resendez on 4/25/20.
//  Copyright © 2020 Samuel Resendez. All rights reserved.
//

import UIKit
import Alamofire

class Appointment {
    var title: String = ""
    var date: String = ""
    var ident: String = "yeeehaw"
    
    init(title: String, date: String, ident: String) {
        self.title = title
        self.date = date
        self.ident = ident
    }
}

class AppointmentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var appointments: [Appointment] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointCell") as! AppointmentTableViewCell
        cell.titleLabel.text = appointments[indexPath.row].title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        cell.dateLabel.text = appointments[indexPath.row].date
        cell.selectionStyle = .none
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
        fetchDataFromSteve()
    }
    
    func fetchDataFromSteve() {
        AF.request("http://167.71.154.158:8000/appointments/" + String(LoginViewController.userId)).validate().responseJSON { response in
            for appt in response.value as! NSArray {
                
                let jsonDict = appt as! NSDictionary
                let location = jsonDict["location"] as! NSDictionary
                let appointment = jsonDict["appointment"] as! NSDictionary
                
                let name = location["name"] as! String
                let time = appointment["timestamp"] as! String
                let ident = appointment["id"] as! Int
                let app = Appointment(title: name, date: time, ident: String(ident))
                self.appointments.append(app)
            }
            self.appointmentTableView.reloadData()
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let ticketVC = segue.destination as? TicketViewController else {
            return
        }
        guard let sender = sender as? UIButton else {
            return
        }
        guard let cell =  sender.superview?.superview as? AppointmentTableViewCell  else {
            return
        }
        
        let indexPath = appointmentTableView.indexPath(for: cell)
        let appointment = appointments[indexPath!.row]
        ticketVC.appointment = appointment
       
    }
    
    @IBAction func deleteRow(_ sender: UIButton) {
        guard let cell =  sender.superview?.superview as? AppointmentTableViewCell  else {
            return
        }
        let indexPath = appointmentTableView.indexPath(for: cell)
        appointments.remove(at: indexPath!.row)
        appointmentTableView.reloadData()
    }
    
}

extension String {
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        print(self)
        dateFormatter.dateFormat = "yyyy' 'MM' 'dd' 'HH:mm::ss"
        let date = dateFormatter.date(from: self)
        return date
    }
}
