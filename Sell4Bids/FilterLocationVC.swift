//
//  FilterLocationVC.swift
//  Sell4Bids
//
//  Created by admin on 7/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import GooglePlacesSearchController
import MapKit

protocol LocationSelectionDelegate {
  func didTappedLocation(LocName:String, Lat:Double, Longitude: Double,country: String,provience:String)
}
protocol updateLocatation {
  func upatelocation()
}

class FilterLocationVC: UIViewController,UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate {
    
    //MARK:- Properties
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locateMeSwitch: UISwitch!
    @IBOutlet weak var LocationTableView: UITableView!
    @IBOutlet weak var selectLocationBtn: UIButton!
    
    
    //MARK:- Variables
    var city  = String()
    var country = String()
    var state = String()
    var zipcode = String()
    var latitude = Double()
    var longtitude = Double()
    var searchCompleter = MKLocalSearchCompleter()
    let locationManager = CLLocationManager()
    var searchResults = [MKLocalSearchCompletion]()
    var newlatitude : Double?
    var newlongitude : Double?
    var marker = GMSMarker()
    var userPickedThePlace : GMSPlace?
    var usersLocation : CLLocation?
    var flagPermissionGranted = true
    var ZpCode_location : Int?
    var City_location : String?
    var State_Location : String?
    var Country_location : String?
    var selectionDelegate: LocationSelectionDelegate?
   var updatelocationdelegate:updateLocatation?
    var OfferStatus = false
    var MainApi = MainSell4BidsApi()
    var itemId = String()
    var orderId = String()
    var locationName = String()
    
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        searchCompleter.delegate = self
        LocationTableView.delegate = self
        LocationTableView.dataSource = self
        locationSearchBar.delegate = self
        locationSearchBar.layer.cornerRadius = 6
        locationSearchBar.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        locationSearchBar.layer.borderWidth = 1.5
        locationSearchBar.layer.masksToBounds = true
        locateMeSwitch.addTarget(self, action: #selector(LocateMeBtn(_:)), for: .allTouchEvents)
      
        selectLocationBtn.shadowView()
        selectLocationBtn.addTarget(self, action: #selector(selectLocationBtnTapped(sender:)), for: .touchUpInside)
        LocationTableView.shadowView()
        mapView.showsUserLocation = true
    }
  override func viewWillAppear(_ animated: Bool) {
      locateMeSwitch.sendActions(for: UIControlEvents.touchUpInside)
//    .setOn(!swcTemp.isOn, animated: true)
    locateMeSwitch.setOn(true, animated: true)
    
    
  }
    
    //MARK:- Actions
    @objc func selectLocationBtnTapped(sender: UIButton){
     
        if OfferStatus == true {
          
          ShareLocationApiCall()
          
     
            
        }else {
          let country = "\(self.country)"
          let provience = "\(self.state) \(self.zipcode) "
          updatelocationdelegate?.upatelocation()
          selectionDelegate?.didTappedLocation(LocName: self.city, Lat: self.latitude, Longitude: self.longtitude, country: country, provience: provience)
          selectionDelegate?.didTappedLocation(LocName: self.city, Lat: self.latitude, Longitude: self.longtitude, country: country, provience: provience)
           NotificationCenter.default.post(name: Notification.Name("updatelocation"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
         
    }
    
    @objc func LocateMeBtn(_ sender: Any) {
        print("called Location")
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    
    //MARK:- Functions
    
    func ShareLocationApiCall(){
       
        let URl = "\(MainApi.IP)\(MainApi.ShareLocation)"
        print(URl)
        let address = city + "," + state + "," + country
        print(address)
        let body:[String:Any] = [
            "item_id": itemId,
            "order_id":orderId,
            "address": address,
            "lat": latitude,
            "lng": longtitude
        ]
        print(body)
        MainApi.postApiCall(URL: URl, param: body) { (success) in
            
            if success{
                let status = self.MainApi.status
                if status == 200 || status == 201 || status == 202{
                    print("200")
                     NotificationCenter.default.post(name: Notification.Name("updatelocation"), object: nil)
                    showSwiftMessageWithParams(theme: .success, title: "Location", body: "Location Share Successfully")
                    self.navigationController?.popViewController(animated: true)
                    
                }
                else{
                    print("Error")
                    showSwiftMessageWithParams(theme: .error, title: "LogIn", body: "Try again")
                }
            }
            else{
                let status = self.MainApi.status
                print(status)
                showSwiftMessageWithParams(theme: .error, title: "LogIn", body: "Try again")
            }
        }
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
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
            if response == nil{
                print("ERROR")
            }else{
                
                //Remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated: true)
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.locateMeSwitch.isOn {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            mapView.mapType = MKMapType.standard
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: locValue, span: span)
            mapView.setRegion(region, animated: true)
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            self.latitude = location.coordinate.latitude
            self.longtitude = location.coordinate.longitude
          
          lookUpCurrentLocation { (placemark) in
            print(placemark!)
          }
            
            geoCoder.reverseGeocodeLocation(location, completionHandler:
                {
                    placemarks, error -> Void in
                    
                    // Place details
                  let placemark = placemarks! as [CLPlacemark]
                    guard let placeMark = placemarks?.first else { return }
                    
                    // Location name
                    if let locationName = placeMark.name {
                        print(locationName)
                        self.locationName = "\(locationName)"
                        
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
                  
                  self.locationSearchBar.text = "\(self.city),\(self.state) \(self.zipcode)"
            })
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locValue
            annotation.title = "Me!"
            annotation.subtitle = "current location"
            mapView.addAnnotation(annotation)
          locationManager.dismissHeadingCalibrationDisplay()
            //centerMap(locValue)
            print(self.country)
        }
        
    }
  
  func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                  -> Void ) {
      // Use the last reported location.
    self.locationManager.requestAlwaysAuthorization()
    // For use in foreground
    self.locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
      if let lastLocation = self.locationManager.location {
          let geocoder = CLGeocoder()
              
          // Look up the location and pass it to the completion handler
          geocoder.reverseGeocodeLocation(lastLocation,
                      completionHandler: { (placemarks, error) in
                        
              if error == nil {
                  let firstLocation = placemarks?[0]
                print(firstLocation?.addressDictionary as Any)
                  completionHandler(firstLocation)
              }
              else {
             // An error occurred during geocoding.
                  completionHandler(nil)
              }
          })
      }
      else {
          // No location was available.
          completionHandler(nil)
      }
  }
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Location"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        
        self.navigationItem.hidesBackButton = true
    }
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        if OfferStatus == false {
          selectionDelegate?.didTappedLocation(LocName: self.city, Lat: self.latitude, Longitude: self.longtitude, country: self.country, provience: self.state)
            self.navigationController?.popViewController(animated: true)
        }else {
           self.navigationController?.popViewController(animated: true)
        }
       
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        
    }
    
    
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
}
extension FilterLocationVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.LocationTableView.isHidden = false
        self.locateMeSwitch.isOn = false
        LocationTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        self.LocationTableView.isHidden = true
        
        // handle error
    }
}
extension FilterLocationVC: UITableViewDataSource ,UITableViewDelegate {
    
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
      self.locationSearchBar.text = completion.title
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
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
//                print("Response == \(response?.mapItems.last?.name)")
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = response?.mapItems[0].name
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                
                self.LocationTableView.isHidden = true
                self.mapView.setRegion(region, animated: true)
            }
            
        }
     
    }
 
}

