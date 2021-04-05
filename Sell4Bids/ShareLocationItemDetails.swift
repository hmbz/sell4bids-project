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


class ShareLocationItemDetails: UIViewController,UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate  {
    
    var MainApi = MainSell4BidsApi()
    var share_address : String?
    var selectedOrder = String()
    var selectedmethod = String()
    var selectedItemid = String()

    
    
    
    @IBAction func Share_Location_Action(_ sender: UIButton) {
        
        
        if latitude == nil && longtitude == nil {
            
            }else{
                print("called Api 3 ")
                
                if selectedmethod == "Orders" {
                    MainApi.Share_Location_Api(address: share_address ?? " " , itemId: selectedItemid, orderId: selectedOrder, lat: self.latitude, lng:  self.longtitude) { (status, data, error) in
                        
                        print("Status == \(status)")
                        print("data == \(data)")
                        print("error == \(error)")
                        
                        
                    }
                }else if selectedmethod == "Offers" {
                    MainApi.Share_Location_Api(address: share_address ?? " " , itemId: selectedItemid, orderId: selectedOrder, lat:latitude , lng: longtitude) { (status, data, error) in
                        
                        print("Status == \(status)")
                        print("data == \(data)")
                        print("error == \(error)")
                        
                        
                    }
                }
                
        }
        
        
        
    }

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
    
    var city  = String()
    var country = String()
    var state = String()
    var zipcode = String()
    var latitude = Double()
    var longtitude = Double()
    
    
    @IBOutlet weak var LocateMe: UISwitch!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    
    @IBOutlet weak var myMapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    
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
                self.latitude = latitude!
                self.longtitude = longitude!
                self.share_address = response?.mapItems[0].placemark.addressDictionary?.values as! String
                
                
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
    
    
    
    var newlatitude : Double?
    var newlongitude : Double?
    
    @objc func select_latlong(lat : Double , long : Double) {
        newlatitude = lat
        newlongitude = long
    }
    var ZpCode_location : Int?
    var City_location : String?
    var State_Location : String?
    var Country_location : String?
    @objc func select_ZipCode_City_State_Country(ZipCode : Int , city : String , state : String , country : String){
        ZpCode_location = ZipCode
        City_location = city
        State_Location = state
        Country_location = country
        
    }
    
    //    func getAutocompletePicker() {
    //        let autocompleteController = GMSAutocompleteViewController()
    ////        autocompleteController.delegate = self
    //        present(autocompleteController, animated: true, completion: nil)
    //    }
    //
    var marker = GMSMarker()
    
    
    
    
    @IBOutlet weak var viewGMSMap: GMSMapView!
    
    var userPickedThePlace : GMSPlace?
    var usersLocation : CLLocation?
    //    private let locationManager = CLLocationManager()
    var flagPermissionGranted = true
    
    
    @IBOutlet weak var Select_location_btn: UIButton!
    @IBAction func searchaddress(_ sender: Any) {
        
        
    }
    
    @IBAction func LocateMeBtn(_ sender: Any) {
        
        print("called Location")
        
        
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
                    
                    
                    let Name = placeMark.name
                    
                    let Street =  placeMark.subLocality
                    
                    let State = placeMark.administrativeArea
                    
                    let CountryCode = placeMark.country
                    
                    
                    
                    self.share_address = "\(Name!) \(Street ?? "") \(State!) \(CountryCode!)"
                    
            })
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locValue
            annotation.title = "Me!"
            annotation.subtitle = "current location"
            myMapView.addAnnotation(annotation)
            locationManager.disallowDeferredLocationUpdates()
            //centerMap(locValue)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
}




extension ShareLocationItemDetails: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.searchResultsTableView.isHidden = false
        self.LocateMe.isOn = false
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        self.searchResultsTableView.isHidden = true
        
        // handle error
    }
}

extension ShareLocationItemDetails: UITableViewDataSource ,UITableViewDelegate {
    
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
            
            //            let citystring = city?.split(separator: ",")
            //
            self.country = (response?.mapItems[0].placemark.country ?? "" )
            self.city =  (response?.mapItems[0].placemark.locality ?? " " )
            
            self.state = (response?.mapItems[0].placemark.administrativeArea ?? "" )
            
            
            
            self.zipcode = (response?.mapItems.last!.placemark.postalCode ?? "")
            
            
            //            self.city = String(citystring!.count - 2)
            self.latitude = coordinate!.latitude
            self.longtitude = coordinate!.longitude
            
            
            
            //
            //
            print("Country == \(self.country) , city ==\(self.city) ,state = \(self.state) ,zipcode == \(self.zipcode)  lat ==\(self.latitude) , long == \(self.longtitude)")
            //
            //
            
            print(String(describing: coordinate))
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
                
                print("Response == \(response?.mapItems.last?.name)")
                
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
                self.myMapView.setRegion(region, animated: true)
            }
            
        }
        
        
        
    }
    
    
    
    
    
}
