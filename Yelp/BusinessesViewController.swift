//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: BusinessDataViewControllerDelegate?
    var searchBar: UISearchBar!
    var loadingMoreView: InfiniteScrollActivityView? //infinite scroll indicator
    
    var isMoreDataLoading = false
    var searchTerm = "Thai"
    var businesses: [Business]?
    {
        didSet
        {
            self.delegate?.didSetBusinesses(business: businesses)
        }
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        searchBar.text = searchTerm
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        //Configure Infinite Scrolling Activity View
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        Business.searchWithTerm(term: searchTerm)
        {
            (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        cell.business = businesses?[indexPath.row]
        
        return cell
    }
    
    
    // Perform the search.
    fileprivate func searchRestaurants(with searchTerm: String)
    {
        Business.searchWithTerm(term: searchTerm)
        {
            (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
        }

    }

    //When the user scrolls
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if !isMoreDataLoading
        {
            //set the thresholds
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging)
            {
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                isMoreDataLoading = true
                loadMoreData()
            }
        }
        
    }
    
    //load more data function
    func loadMoreData()
    {
        Business.searchWithTerm(term: searchTerm, offset: (self.businesses?.count)!)
        {
            (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses?.append(contentsOf: businesses!)
            self.delegate?.didSetBusinesses(business: businesses)
            self.loadingMoreView!.stopAnimating()
            self.isMoreDataLoading = false
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "detailsSegue"
        {
            let cell = sender as! BusinessCell
            let VC = segue.destination as! BusinessDetailsViewController
            VC.business = cell.business
        }
    }
    
    //Search Bar Delegate Functions
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        guard let searchBarText = searchBar.text else { return }
        searchTerm = searchBarText
        searchRestaurants(with: searchTerm)
        searchBar.resignFirstResponder()
    }
    
}
