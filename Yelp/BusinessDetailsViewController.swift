//
//  BusinessDetailsViewController.swift
//  Yelp
//
//  Created by daniel on 1/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailsViewController: UIViewController
{
    
    @IBOutlet weak var backgImageView: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var businessMapView: MKMapView!
    
    var business: Business!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nameLabel.text = business.name
        navigationItem.title = business.name
        
        if let imageURL = business.imageURL
        {
            backgImageView.setImageWith(imageURL)
            thumbImageView.setImageWith(imageURL)
        }
        distanceLabel.text = business.distance
        ratingImageView.setImageWith(business.ratingImageURL!)
        reviewsLabel.text = "\(business.reviewCount!) reviews"
        addressLabel.text = business.address
        categoryLabel.text = business.categories
        
        backgImageView.addBlurEffect()
        thumbImageView.makeCircular()
        
        businessMapView.addAnnotationOfAndGoTo(address: business.address!, title: business.name!)
    }
}
