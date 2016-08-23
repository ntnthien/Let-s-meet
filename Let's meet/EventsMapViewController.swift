//
//  EventsMapViewController.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/6/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import GoogleMaps
import ReactiveKit
import ReactiveUIKit

class EventsMapViewController: BaseViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var items = CollectionProperty<[Event]>([])
    
    let locationManager = CLLocationManager()
    var didFindMyLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        loadData()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
        mapView.camera = camera
        
        
//        getLatitude()
//        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 2.0)
//        mapView.camera = camera
//        mapView.delegate = self
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)

        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            mapView.settings.myLocationButton = true
            didFindMyLocation = true
            print("My location is \(mapView.myLocation)")

        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit{
        removeObserver(self, forKeyPath: "myLocation", context: nil)
        
    }
    override func loadView() {
        super.loadView()
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        let camera = GMSCameraPosition.cameraWithLatitude(10.7803616, longitude: 106.6860085, zoom: 15.0)
        mapView.camera = camera
        mapView.myLocationEnabled = true
        mapView.mapType = kGMSTypeNormal
        mapView.indoorEnabled = false
        mapView.myLocationEnabled = true
        print("my location is \(mapView.myLocation)")
//        let location = (mapView.myLocation != nil) ? mapView.myLocation! : CLLocation(latitude: 10.7803616, longitude: 106.6860085)
//        serviceInstance.getNearByEvents(location, radius: 10) { (key, location) in
//            let marker = GMSMarker()
//            marker.position = location.coordinate
//            marker.title = "Docker Meetup - \(key)"
//            marker.snippet = "Work Sai Gon"
//            
//            marker.map = self.mapView
//            
////            self.mapView.addSubview(mapView)
//        }
        
        
        
        // Creates a marker in the center of the map.
       
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
    
    
    func loadData() {
        serviceInstance.getJoinedEvents { (events: [Event?]) in
            self.items.removeAll()

            for event in events {
                self.items.append(event!)
            }
        }
    }
    
    
    func setUpTableView() {
        
        //        tableView.delegate = self
        tableView.rDataSource.forwardTo = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        items.bindTo(tableView) { [weak self] indexPath, dataSource, tableView in
            guard let weakSelf = self else { return UITableViewCell() }
            
            let cell = weakSelf.tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! EventHeaderTableViewCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.configureCell(self!.items[indexPath.row])
            return cell
        }
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
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
extension EventsMapViewController: UITableViewDelegate {
    
}

// MARK: - CLLocationManagerDelegate
extension EventsMapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.myLocationEnabled = true
            print("My location: \(mapView.myLocation)")
            locationManager.startUpdatingLocation()
            //mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            print("My location: \(mapView.myLocation)")
            locationManager.stopUpdatingLocation()
        }
        
    }
}

extension EventsMapViewController: GMSMapViewDelegate {
    
}


extension EventsMapViewController: ActionTableViewCellDelegate {
    func actionTableViewCell(actionTableViewCell: UITableViewCell, didTouchButton button: UIButton) {
        switch button.tag {
        case 60:
            print("Profile button touched")
            if let indexPath = (actionTableViewCell as? EventHeaderTableViewCell)?.indexPath, hostID = items[indexPath.row].hostID {
                showProfileViewController(hostID)
            }
        default:
            print("Unassigned button touched")
        }
    }
}

