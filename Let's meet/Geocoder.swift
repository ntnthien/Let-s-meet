//
//  Geocoder.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/22/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation
import GoogleMaps


class Geocoder {
    private static let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    private static let apikey = "AIzaSyCqbPtzws6qpHd7V_JE7lNNZuLh3j6cejk"
    
    static func getLatLngForZip(zipCode: String) {
        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
            if let geometry = result[0]["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    let latitude = location["lat"] as! Float
                    let longitude = location["lng"] as! Float
                    print("\n\(latitude), \(longitude)")
                }
            }
        }
    }
//    -> CLLocationCoordinate2D? 
    
    static func getLatLngForAddress(address: String) -> CLLocation? {
        let url = NSURL(string: "\(baseUrl)address=\(address.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&key=\(apikey)")
        print(url?.absoluteString)

        if let data = NSData(contentsOfURL: url!) {
            let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray {
                for data in result {
                    if let geometry = data["geometry"] as? NSDictionary {
                        if let location = geometry["location"] as? NSDictionary {
                            let latitude = location["lat"] as! Double
                            let longitude = location["lng"] as! Double
                                                    print("\n\(latitude), \(longitude)")
                            return CLLocation(latitude: latitude, longitude: longitude)
                        }
                    }
                }
            }
        }
        return nil
    }
    
    static func getAddressForLatLng(latitude: String, longitude: String) {
        let url = NSURL(string: "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(apikey)")
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
            if let address = result[0]["address_components"] as? NSArray {
                let number = address[0]["short_name"] as! String
                let street = address[1]["short_name"] as! String
                let city = address[2]["short_name"] as! String
                let state = address[4]["short_name"] as! String
                let zip = address[6]["short_name"] as! String
                print("\n\(number) \(street), \(city), \(state) \(zip)")
            }
        }
    }
   
}


extension CLLocationCoordinate2D {
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
