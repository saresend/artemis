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

class MapBaseViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var baseUIMap: MKMapView!
    var currUserLocation: CLLocation? = nil
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationConfig()
        let points = [(38.5449, -121.7405), (38.546487, -121.761509), (38.544387, -121.743470), (38.544127, -121.742711), (38.554487, -121.786970)]
        let annotations = generateAnnotations(points: points)
        for annotation in annotations {
            print("Adding annotation", annotation)
            baseUIMap.addAnnotation(annotation)
        }
        baseUIMap.showAnnotations(baseUIMap.annotations, animated: true)
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
            marker.glyphText = "Trader Joes"
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
