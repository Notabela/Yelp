//
//  Helper.swift
//  Yelp
//
//  Created by daniel on 1/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    func makeCircular()
    {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}

extension MKMapView
{
    func addAnnotationOfAndGoTo(address: String, title name: String = "")
    {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address)
        {
            (placemarks, error) -> Void in
            
            if let placemark = placemarks?.first
            {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = name
                
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinates, span)
                self.setRegion(region, animated: false)
                self.addAnnotation(annotation)
            }
        }
    }
    
    func addAnnotationOf(address: String, title name: String = "")
    {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address)
        {
            (placemarks, error) -> Void in
            
            if let placemark = placemarks?.first
            {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = name
                self.addAnnotation(annotation)
            }
        }
    }
    
    func goToLocation(location_2d: CLLocationCoordinate2D)
    {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location_2d, span)
        self.setRegion(region, animated: false)
    }
}

//GeoCode a Address and return coordinates of the address
func geoCodeLocation(address: String, completion: @escaping (_ location: CLLocationCoordinate2D) -> Void)
{
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address)
    {
        (placemarks, error) -> Void in
        
        if error == nil
        {
            if let placemark = placemarks?.first
            {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                completion(coordinates)
            }
        }
    }
    
}
    
