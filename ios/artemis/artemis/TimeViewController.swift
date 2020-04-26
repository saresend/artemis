//
//  TimeViewController.swift
//  artemis
//
//  Created by Sophia Zheng on 4/25/20.
//  Copyright © 2020 Samuel Resendez. All rights reserved.
//

import UIKit
import Alamofire

struct ApptParams: Encodable {
    var len: Int
    var timestamp: String
    var location_id: Int
    var user_id: Int
    
    init(timeStamp: String, location_id: Int) {
        self.len = 1
        self.timestamp = timeStamp
        self.location_id = location_id
        self.user_id = LoginViewController.userId
    }
    
}

class TimeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    var date: Date?
    var locationID = 0
    private var nextViewNumber = Int()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! TimeCollectionViewCell
        
        let calendar = Calendar.current
        cell.time = calendar.date(byAdding: .hour, value: 8 + indexPath.row + indexPath.section * 3, to: date!)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        cell.timeLabel.text = formatter.string(from:cell.time!)
        cell.timeLabel.layer.borderWidth = 3.0
        cell.timeLabel.layer.cornerRadius = 8
        cell.timeLabel.layer.borderColor = UIColor.clear.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimeCollectionViewCell
        print("selected")
        cell.timeLabel.layer.borderColor = UIColor(red: 0.77, green: 0.87, blue: 0.96, alpha: 1.00).cgColor
        date = cell.time
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimeCollectionViewCell
        cell.timeLabel.layer.borderColor = UIColor.clear.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTabBar" {
            let nextView = segue.destination as! UITabBarController
            nextView.selectedIndex = nextViewNumber
        }
    }
    
    func dispatchSave(loc_id: Int, timestamp: String) {
        let params = ApptParams(timeStamp: timestamp, location_id: loc_id)
        print(params)
        let result = AF.request("http://167.71.154.158:8000/appointments/add", method: .post, parameters: params, encoder: JSONParameterEncoder.default).response { response in
            print(response)
        }
    }
    
    @IBAction func saveAppointment(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        let timeText = formatter.string(from:date!)
        dispatchSave(loc_id: locationID, timestamp: timeText)
        let alert = UIAlertController(title: "Appointment Confirmed", message: timeText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("View", comment: "Go to Appointments"), style: .default, handler: { _ in
            self.nextViewNumber = 1
            self.performSegue(withIdentifier: "toTabBar", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Go to Map"), style: .default, handler: { _ in
            self.nextViewNumber = 0
            self.performSegue(withIdentifier: "toTabBar", sender: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var timeCollectionView: UICollectionView!
    override func viewDidLoad() {
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateText = formatter.string(from:date!)
        titleLabel.text = "Choose Time for " + dateText
        // Do any additional setup after loading the view.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension TimeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.5, height: 50)
    }
}
