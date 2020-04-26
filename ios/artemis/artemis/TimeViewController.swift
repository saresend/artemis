//
//  TimeViewController.swift
//  artemis
//
//  Created by Sophia Zheng on 4/25/20.
//  Copyright © 2020 Samuel Resendez. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    var date: Date?
    private var nextViewNumber = Int()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! TimeCollectionViewCell
        
        let calendar = Calendar.current
        cell.time = calendar.date(byAdding: .hour, value: 4 + indexPath.row, to: date!)
        let formatter = DateFormatter()
        formatter.timeStyle = .short

        cell.timeLabel.text = formatter.string(from:cell.time!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimeCollectionViewCell
        cell.selectedLabel.textColor = UIColor.lightGray
        date = cell.time
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TimeCollectionViewCell
        cell.selectedLabel.textColor = UIColor.clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTabBar" {
            let nextView = segue.destination as! UITabBarController
            nextView.selectedIndex = nextViewNumber
        }
    }
    
    @IBAction func saveAppointment(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        let timeText = formatter.string(from:date!)
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
