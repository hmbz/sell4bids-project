//
//  ItemListingFour.swift
//  Sell4Bids
//
//  Created by admin on 13/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import GooglePlacesSearchController

import MapKit


class ItemListingFour: UIViewController,UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate  {
    
    
    
    
    //MARK:- Properties and Outlets
    @IBOutlet weak var LocateMe: UISwitch!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var Searchbar: UISearchBar!
    @IBOutlet weak var locateMeLbl: UILabel!
    
    //MARK:- Variable
    var city  = String()
    var country = String()
    var state = String()
    var zipcode = String()
    var latitude = Double()
    var longtitude = Double()
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    let locationManager = CLLocationManager()
    var newlatitude : Double?
    var newlongitude : Double?
    var ZpCode_location : Int?
    var City_location : String?
    var State_Location : String?
    var Country_location : String?
    var marker = GMSMarker()
    var userPickedThePlace : GMSPlace?
    var usersLocation : CLLocation?
    var flagPermissionGranted = true
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        Searchbar.layer.cornerRadius = 8
        Searchbar.layer.masksToBounds = true
        Searchbar.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Searchbar.layer.borderWidth = 0.5
        searchResultsTableView.layer.cornerRadius = 6
        searchResultsTableView.layer.masksToBounds = true
        
        locateMeLbl.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        locateMeLbl.layer.shadowRadius = 2.0
        locateMeLbl.layer.shadowOpacity = 1.0
        locateMeLbl.layer.shadowOffset = CGSize(width: 0, height: 1)
        locateMeLbl.layer.masksToBounds = false
    }
    
    //MARK:- Functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                print("Response == \(response?.mapItems.last?.name)")
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myMapView.setRegion(region, animated: true)
            }
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if searchBar.text!.isEmpty {
            searchResultsTableView.reloadData()
            searchResultsTableView.isHidden = true
        }
       return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with:event)
        let touch = touches.first
        if touch?.view == myMapView {
            searchResultsTableView.isHidden = true
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if self.LocateMe.isOn {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            myMapView.mapType = MKMapType.standard
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: locValue, span: span)
            myMapView.setRegion(region, animated: true)
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            self.latitude = location.coordinate.latitude
            self.longtitude = location.coordinate.longitude
            
            geoCoder.reverseGeocodeLocation(location, completionHandler:
                {
                    placemarks, error -> Void in
                    
                    // Place details
                    guard let placeMark = placemarks?.first else { return }
                    
                    // Location name
                    if let locationName = placeMark.location {
                        print(locationName)
                    }
                    // Street address
                    if let street = placeMark.thoroughfare {
                        print(street)
                    }
                    // City
                    if let city = placeMark.locality {
                        print(city)
                        self.city = city
                    }
                    // Zip code
                    if let zip = placeMark.postalCode {
                        print(zip)
                        self.zipcode = zip
                    }
                    // Country
                    if let country = placeMark.country {
                        print(country)
                        self.country = country
                    }
                    
                    if let state = placeMark.administrativeArea {
                        print(state)
                        self.state = state
                        
                    }
                   
            })
            self.Searchbar.text = "\(self.city), \(self.state) \(self.zipcode)"
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locValue
            annotation.title = "Me!"
            annotation.subtitle = "current location"
            myMapView.addAnnotation(annotation)
            locationManager.disallowDeferredLocationUpdates()
            //centerMap(locValue)
            print(self.country)
        }
        
    }
    
    
    //MARK:- Actions
    @objc func select_latlong(lat : Double , long : Double) {
        newlatitude = lat
        newlongitude = long
    }
    
    @objc func select_ZipCode_City_State_Country(ZipCode : Int , city : String , state : String , country : String){
        ZpCode_location = ZipCode
        City_location = city
        State_Location = state
        Country_location = country
        
    }
    
    @IBAction func LocateMeBtn(_ sender: UISwitch) {
        
        print("called Location")
        if sender.isOn == true{
            self.locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
            
            myMapView.delegate = self
            myMapView.mapType = .standard
            myMapView.isZoomEnabled = true
            myMapView.isScrollEnabled = true
            
            if let coor = myMapView.userLocation.location?.coordinate{
                myMapView.setCenter(coor, animated: true)
            }
        }else{
            self.country = ""
            self.state = ""
            self.city = ""
            self.zipcode = ""
            self.latitude = 0.0
            self.longtitude = 0.0
        }
    }
}




extension ItemListingFour: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.searchResultsTableView.isHidden = false
        self.LocateMe.isOn = false
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.searchResultsTableView.isHidden = true
    }
}

extension ItemListingFour: UITableViewDataSource ,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("home")
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate

            self.country = (response?.mapItems[0].placemark.country ?? "" )
            self.city =  (response?.mapItems[0].placemark.locality ?? " " )
            self.state = (response?.mapItems[0].placemark.administrativeArea ?? "" )
            self.zipcode = (response?.mapItems.last!.placemark.postalCode ?? "")
            self.latitude = coordinate!.latitude
            self.longtitude = coordinate!.longitude
            
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = response?.mapItems[0].name
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                
                self.searchResultsTableView.isHidden = true
                self.Searchbar.text = "\(self.searchResults[indexPath.row].title)"
                self.myMapView.setRegion(region, animated: true)
            }
        }
    }
}





