//
//  LocationViewController.swift
//  Sell4Bids
//
//  Created by admin on 11/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate {
    
    //MARK:- Properties and outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var selectLocationBtn: UIButton!
    @IBOutlet weak var locateMeSwitch: UISwitch!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var locateMeLbl: UILabel!
    
    //MARK:- Variables and constant
    var searchResults = [MKLocalSearchCompletion]()
    var country :String?
    var city :String?
    var state :String?
    var zipcode :String?
    var latitude :Double?
    var longtitude :Double?
    var searchCompleter = MKLocalSearchCompleter()
    let locationManager = CLLocationManager()
    lazy var itemId = ""
    lazy var orderId = ""
    lazy var locationName = String()
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        topMenu()
    }
    
    //MARK:- Private Functions
    
    private func setupViews() {
        selectLocationBtn.shadowView()
        searchCompleter.delegate = self
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationSearchBar.delegate = self
        locationSearchBar.layer.cornerRadius = 6
        locationSearchBar.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        locationSearchBar.layer.borderWidth = 1.5
        locationSearchBar.layer.masksToBounds = true
        
        locateMeLbl.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        locateMeLbl.layer.shadowRadius = 2.0
        locateMeLbl.layer.shadowOpacity = 1.0
        locateMeLbl.layer.shadowOffset = CGSize(width: 0, height: 1)
        locateMeLbl.layer.masksToBounds = false
        
        locateMeSwitch.addTarget(self, action: #selector(LocateMeBtn(_:)), for: .allTouchEvents)
        selectLocationBtn.shadowView()
        selectLocationBtn.addTarget(self, action: #selector(selectLocationBtnTapped(sender:)), for: .touchUpInside)
        locationTableView.shadowView()
        mapView.showsUserLocation = true
    }
    
    //MARK:- Actions
    @objc func selectLocationBtnTapped(sender: UIButton){
        ShareLocationApiCall()
      

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
  override func viewWillAppear(_ animated: Bool) {
     locateMeSwitch.sendActions(for: UIControlEvents.touchUpInside)
     //    .setOn(!swcTemp.isOn, animated: true)
    locateMeSwitch.setOn(true, animated: true)
  }
    
    
    //MARK:- Functions
    
    func ShareLocationApiCall(){
        
        let address = "\(self.city ?? ""), \(self.state ?? "") \(self.zipcode ?? "")"
        let body:[String:Any] = [
            "item_id": self.itemId ,
            "order_id":self.orderId ,
            "address": address,
            "lat": latitude ?? 0,
            "lng": longtitude ?? 0
        ]
        print(body)
        Networking.instance.postApiCall(url: sellerShareLocationUrl, param: body) { (response, Error, StatusCode) in
            guard let jsonDic = response.dictionary else {return}
            let jsonStatus = jsonDic["status"]?.bool ?? false
            if jsonStatus == true {
                let message = jsonDic["message"]?.string ?? ""
                showSwiftMessageWithParams(theme: .success, title: "StrSelectLocation".localizableString(loc: LanguageChangeCode), body: message)
              NotificationCenter.default.post(name: Notification.Name("update"), object: nil)
                self.dismiss(animated: true, completion: nil)
            }else {
                showSwiftMessageWithParams(theme: .success, title: "StrSelectLocation".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
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
            
            geoCoder.reverseGeocodeLocation(location, completionHandler:
                {
                    placemarks, error -> Void in
                    
                    // Place details
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
                    let address = "\(self.city ?? ""), \(self.state ?? "") \(self.zipcode ?? "")"
                    self.locationSearchBar.text = address
            })
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locValue
            annotation.title = "Me!"
            annotation.subtitle = "current location"
            mapView.addAnnotation(annotation)
            locationManager.disallowDeferredLocationUpdates()
        }
        
    }
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        titleview.titleLbl.text = "Location"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.titleView = titleview
    }
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        
    }
    
    
    
    override func viewLayoutMarginsDidChange() {
//        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
    }
    
}
extension LocationViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.locationTableView.isHidden = false
        self.locateMeSwitch.isOn = false
        locationTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        self.locationTableView.isHidden = true
        // handle error
    }
}
extension LocationViewController: UITableViewDataSource ,UITableViewDelegate {
    
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
            print(String(describing: coordinate))
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil{
                print("ERROR")
            }
            else{
                //Remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
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
                
                self.locationTableView.isHidden = true
                self.mapView.setRegion(region, animated: true)
            }
            
        }
    }
}
