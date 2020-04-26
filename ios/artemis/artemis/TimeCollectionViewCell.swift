//
//  TimeCollectionViewCell.swift
//  artemis
//
//  Created by Sophia Zheng on 4/25/20.
//  Copyright © 2020 Samuel Resendez. All rights reserved.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var selectedLabel: UITextField!
    
    var time: Date?
}
