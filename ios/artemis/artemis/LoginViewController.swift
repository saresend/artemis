//
//  LoginViewController.swift
//  artemis
//
//  Created by Samuel Resendez on 4/25/20.
//  Copyright © 2020 Samuel Resendez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var sunsetView: UIView!
    @IBOutlet var signInButton: UIButton!
    static var userId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginViewController.userId = 1
        signInButton.backgroundColor = ThemeBlue
        signInButton.titleLabel?.textColor = UIColor.white
        signInButton.layer.cornerRadius = 30
        sunsetView.backgroundColor = ThemeOrange
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: sunsetView.bounds.size.width / 2, y: sunsetView.bounds.size.height), radius: sunsetView.bounds.size.height / 2  , startAngle: 0.0, endAngle: CGFloat(M_PI), clockwise: false)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        sunsetView.layer.mask = circleShape
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
