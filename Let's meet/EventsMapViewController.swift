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
    
    let locationManager = CLLocationManager()
    
    var items = CollectionProperty<[Event]>([])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //instantiate a CLLocationManager property named locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        getLatitude()
        
        setUpTableView()
        loadData()

        
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
    
    
    func loadData() {
        self.items.removeAll()
        
        FirebaseAPI.sharedInstance.getEvents { (events: [Event?]) in
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

