//
//  MapBusinessesViewController.swift
//  Yelp
//
//  Created by daniel on 1/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapBusinessesViewController: UIViewController, MKMapViewDelegate, BusinessDataViewControllerDelegate
{

    @IBOutlet weak var BusinessMapView: MKMapView!
    var mustReload: Bool = false
    var businesses: [Business]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let navController = tabBarController?.viewControllers?[0] as? UINavigationController
        let busVC = navController?.viewControllers[0] as? BusinessesViewController
        busVC?.delegate = self
        businesses = busVC?.businesses
        addAnotationsOf(businesses: businesses)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        guard mustReload else
        {
            return
        }
        
        let anotations = BusinessMapView.annotations
        BusinessMapView.removeAnnotations(anotations)
        addAnotationsOf(businesses: businesses)
        mustReload = false
    }
    
    func didSetBusinesses(business: [Business]?)
    {
        mustReload = true
        businesses = business
    }
    
    func addAnotationsOf(businesses: [Business]?)
    {
        if let businesses = businesses
        {
            geoCodeLocation(address: (businesses.last?.address)!)
            {
                (coordinates) in
                
                self.BusinessMapView.goToLocation(location_2d: coordinates)
            }
            
            for business in businesses
            {
                BusinessMapView.addAnnotationOf(address: business.address!, title: business.name!)
            }
        }

    }
}

protocol BusinessDataViewControllerDelegate: class
{
    func didSetBusinesses(business: [Business]?)
}

