//
//  EventsMapViewController.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/6/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import GoogleMaps

class EventsMapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //instantiate a CLLocationManager property named locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        getLatitude()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        let camera = GMSCameraPosition.cameraWithLatitude(10.7803616, longitude: 106.6860085, zoom: 17.0)
        let mapView = GMSMapView.mapWithFrame(self.mapView.bounds, camera: camera)
        dispatch_async(dispatch_get_main_queue()) { 
            mapView.myLocationEnabled = true

        }
        mapView.mapType = kGMSTypeNormal
        mapView.indoorEnabled = false
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 10.7803616, longitude: 106.6860085)
        marker.title = "Docker Meetup"
        marker.snippet = "Work Sai Gon"
        
        marker.map = mapView
        
        self.mapView.addSubview(mapView)
    }
 
    func getLatitude() {
        let address = "1 Infinite Loop, CA, USA"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                coordinates.latitude
                coordinates.longitude
                print("lat", coordinates.latitude)
                print("long", coordinates.longitude)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension EventsMapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}

// MARK: - CLLocationManagerDelegate
extension EventsMapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            
            // 4
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
        
    }
}

extension EventsMapViewController: GMSMapViewDelegate {
    
}
