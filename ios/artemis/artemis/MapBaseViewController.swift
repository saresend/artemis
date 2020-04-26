//
//  MapBaseViewController.swift
//  artemis
//
//  Created by Samuel Resendez on 4/24/20.
//  Copyright © 2020 Samuel Resendez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MapBaseViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var baseUIMap: MKMapView!
    var currUserID: Int = 0
    var currUserLocation: CLLocation? = nil
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationConfig()
        requestLocations()
    }
    
    func requestLocations() {
        AF.request("http://167.71.154.158:8000/location").validate().responseJSON { response in
            for location in response.value as! NSArray {
                let jsonDict = location as! NSDictionary
                let point = (jsonDict["name"] as! String, jsonDict["lat"] as! Double, jsonDict["lng"] as! Double)
                let annotation = self.createAnnotation(point: point)
                self.baseUIMap.addAnnotation(annotation)
            }
            self.baseUIMap.showAnnotations(self.baseUIMap.annotations, animated: true)
        }
    }
    
    func createAnnotation(point: (String, Double, Double)) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: point.1, longitude: point.2)
        annotation.title = point.0
        return annotation
    }
    
    func setupLocationConfig() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        baseUIMap.delegate = self
        baseUIMap.showsUserLocation = true
    }
    
    func generateAnnotations(points: [(Double, Double)]) -> [MKAnnotation] {
        var annotations: [MKAnnotation] = []
        for point in points {
            let annotation = MKPointAnnotation()
            print(point)
            annotation.coordinate = CLLocationCoordinate2D(latitude: point.0, longitude: point.1)
            annotations.append(annotation)
        }
        return annotations
    }
    
    func locationManager(_ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation])
    {
      
        if currUserLocation == nil {
            currUserLocation = locations.last
            let region = MKCoordinateRegion( center: currUserLocation!.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
            baseUIMap.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Pin Tapped")
        performSegue(withIdentifier: "toSchedule", sender: view)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let pinIdent = "Pin";
            var marker: MKMarkerAnnotationView;
            if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKMarkerAnnotationView {
                dequedView.annotation = annotation
                marker = dequedView
            } else {
                marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: pinIdent)
            }
            marker.displayPriority = .required
            return marker
        }
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
