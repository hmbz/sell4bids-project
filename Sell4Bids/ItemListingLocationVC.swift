//
//  ItemListingLocationVC.swift
//  Sell4Bids
//
//  Created by admin on 12/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class ItemListingLocationVC: UIViewController,UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate {
    
    //MARK:- Outlets and Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locateMeSwitch: UISwitch!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var locateMeLbl: UILabel!
    
    //MARK:- Variable and Constent
    var imageArray = [UIImage]()
    lazy var paramDic = [String:Any]()
    var searchCompleter = MKLocalSearchCompleter()
    let locationManager = CLLocationManager()
    var searchResults = [MKLocalSearchCompletion]()
    var city  = String()
    var country = String()
    var state = String()
    var zipcode = String()
    var latitude = Double()
    var longtitude = Double()
    var isoCountryCode = String()
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    var controllerName : String?
    lazy var housingCategory = ""
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        setupViews()
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Actions
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
    
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
    @objc func nextBtnTapped(sender: UIButton){
        if self.country == "" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select location to continue")
        }else {
            if controllerName == "item"{
                itemPush()
            }
            else if controllerName == "job" {
                jobPush()
            }
            else if controllerName == "service"{
                servicePush()
            }
            else if controllerName == "vehicle"{
                vehiclePush()
            }
            else {
                HousingPush()
            }
        }
        
    }
    
    //MARK:- Function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Location"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    private func setupViews() {
        print("Parameters",self.paramDic)
        print("ImagesArray",self.imageArray)
        searchCompleter.delegate = self
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.delegate = self
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 6
        searchBar.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchBar.layer.borderWidth = 1.5
        searchBar.layer.masksToBounds = true
        locateMeSwitch.addTarget(self, action: #selector(LocateMeBtn(_:)), for: .allTouchEvents)
        nextBtn.addTarget(self, action: #selector(nextBtnTapped(sender:)), for: .touchUpInside)
        locationTableView.shadowView()
        mapView.showsUserLocation = true
        locateMeLbl.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        locateMeLbl.layer.shadowRadius = 2.0
        locateMeLbl.layer.shadowOpacity = 1.0
        locateMeLbl.layer.shadowOffset = CGSize(width: 0, height: 1)
        locateMeLbl.layer.masksToBounds = false
    }
    
    private func itemPush() {
        print("On Item")
        let SB = UIStoryboard(name: "Listing", bundle: nil)
        let vc = SB.instantiateViewController(withIdentifier: "ItemListingPostVC") as! ItemListingPostVC
        vc.country = self.country
        vc.imageArray = self.imageArray
        vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
        vc.paramDic.updateValue(self.paramDic["itemCategory"] ?? "", forKey: "itemCategory")
        vc.paramDic.updateValue(self.paramDic["condition"] ?? "", forKey: "condition")
        vc.paramDic.updateValue(self.paramDic["description"] ?? "", forKey: "description")
        vc.paramDic.updateValue(self.latitude, forKey: "lat")
        vc.paramDic.updateValue(self.longtitude, forKey: "lng")
        let token = SessionManager.shared.fcmToken
        vc.paramDic.updateValue(token, forKey: "token")
        let name = SessionManager.shared.name
        vc.paramDic.updateValue(name, forKey: "name")
        let uid = SessionManager.shared.userId
        vc.paramDic.updateValue(uid, forKey: "uid")
        vc.paramDic.updateValue(self.isoCountryCode, forKey: "country_code")
        vc.paramDic.updateValue(self.city, forKey: "city")
        vc.paramDic.updateValue(self.zipcode, forKey: "zipcode")
        vc.paramDic.updateValue(self.state, forKey: "state")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func jobPush() {
        print("On Job")
        let SB = UIStoryboard(name: "Listing", bundle: nil)
        let vc = SB.instantiateViewController(withIdentifier: "JobListingPostVC") as! JobListingPostVC
        vc.country = self.country
        
//        Previous
        vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
        vc.paramDic.updateValue(self.paramDic["jobCategory"] ?? "", forKey: "jobCategory")
        vc.paramDic.updateValue(self.paramDic["description"] ?? "", forKey: "description")
        vc.paramDic.updateValue(self.paramDic["jobExperience"] ?? "", forKey: "jobExperience")
        vc.paramDic.updateValue(self.paramDic["companyName"] ?? "", forKey: "companyName")
        vc.paramDic.updateValue(self.paramDic["companyDescription"] ?? "", forKey: "companyDescription")
        vc.paramDic.updateValue(self.paramDic["Medical"] ?? "", forKey: "Medical")
        vc.paramDic.updateValue(self.paramDic["PTO"] ?? "", forKey: "PTO")
        vc.paramDic.updateValue(self.paramDic["FZOK"] ?? "", forKey: "FZOK")
        vc.paramDic.updateValue(self.paramDic["employmentType"] ?? "", forKey: "employmentType")
//        New
        vc.paramDic.updateValue(self.latitude, forKey: "lat")
        vc.paramDic.updateValue(self.longtitude, forKey: "lng")
        let token = SessionManager.shared.fcmToken
        vc.paramDic.updateValue(token, forKey: "token")
        let name = SessionManager.shared.name
        vc.paramDic.updateValue(name, forKey: "name")
        let image = SessionManager.shared.image
        vc.paramDic.updateValue(image, forKey: "image")
        let uid = SessionManager.shared.userId
        vc.paramDic.updateValue(uid, forKey: "uid")
        vc.paramDic.updateValue(self.isoCountryCode, forKey: "country_code")
        vc.paramDic.updateValue(self.city, forKey: "city")
        vc.paramDic.updateValue(self.zipcode, forKey: "zipcode")
        vc.paramDic.updateValue(self.state, forKey: "state")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func servicePush() {
        print("On service")
        let SB = UIStoryboard(name: "Listing", bundle: nil)
        let vc = SB.instantiateViewController(withIdentifier: "ServiceListingPostVC") as! ServiceListingPostVC
        vc.country = self.country
        vc.imageArray = self.imageArray
        
        vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
        vc.paramDic.updateValue(self.paramDic["userRole"] ?? "", forKey: "userRole")
        vc.paramDic.updateValue(self.paramDic["itemCategory"] ?? "", forKey: "itemCategory")
        vc.paramDic.updateValue(self.paramDic["description"] ?? "", forKey: "description")
        vc.paramDic.updateValue(self.paramDic["serviceType"] ?? "", forKey: "serviceType")
        
        
        vc.paramDic.updateValue(self.latitude, forKey: "lat")
        vc.paramDic.updateValue(self.longtitude, forKey: "lng")
        let token = SessionManager.shared.fcmToken
        vc.paramDic.updateValue(token, forKey: "token")
        let name = SessionManager.shared.name
        vc.paramDic.updateValue(name, forKey: "name")
        let uid = SessionManager.shared.userId
        vc.paramDic.updateValue(uid, forKey: "uid")
        let image = SessionManager.shared.image
        vc.paramDic.updateValue(image, forKey: "image")
        vc.paramDic.updateValue(self.isoCountryCode, forKey: "country_code")
        vc.paramDic.updateValue(self.city, forKey: "city")
        vc.paramDic.updateValue(self.zipcode, forKey: "zipcode")
        vc.paramDic.updateValue(self.state, forKey: "state")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func vehiclePush() {
        print("On Vehicle")
        let SB = UIStoryboard(name: "Listing", bundle: nil)
        let vc = SB.instantiateViewController(withIdentifier: "VehicleListingStepThreeVC") as! VehicleListingStepThreeVC
        vc.country = self.country
        vc.imageArray = self.imageArray
        vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
        vc.paramDic.updateValue(self.paramDic["description"] ?? "", forKey: "description")
        vc.paramDic.updateValue(self.paramDic["condition"] ?? "", forKey: "condition")
        // New Elemets
        vc.paramDic.updateValue(self.latitude, forKey: "lat")
        vc.paramDic.updateValue(self.longtitude, forKey: "lng")
        let token = SessionManager.shared.fcmToken
        vc.paramDic.updateValue(token, forKey: "token")
        let name = SessionManager.shared.name
        vc.paramDic.updateValue(name, forKey: "name")
        let uid = SessionManager.shared.userId
        vc.paramDic.updateValue(uid, forKey: "uid")
        let image = SessionManager.shared.image
        vc.paramDic.updateValue(image, forKey: "image")
        vc.paramDic.updateValue(self.isoCountryCode, forKey: "country_code")
        vc.paramDic.updateValue(self.city, forKey: "city")
        vc.paramDic.updateValue(self.zipcode, forKey: "zipcode")
        vc.paramDic.updateValue(self.state, forKey: "state")
        if self.country == "United States" || self.country == "India"{
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            showSwiftMessageWithParams(theme: .info, title: "Share Location", body: "Currently, vehicle listing is not available in your country")
        }
    }
    
    private func HousingPush() {
        print("On Housing")
        let SB = UIStoryboard(name: "Listing", bundle: nil)
        let vc = SB.instantiateViewController(withIdentifier: "HousingListingPostVC") as! HousingListingPostVC
        vc.country = self.country
        vc.imageArray = self.imageArray
        
        if housingCategory == "Rooms & Shared" || housingCategory == "Sublets & Temporary"{
            vc.paramDic.updateValue("Housing", forKey: "itemCategory")
            vc.paramDic.updateValue(self.paramDic["housingType"] ?? "", forKey: "housingType")
            vc.paramDic.updateValue(self.paramDic["bedrooms"] ?? "", forKey: "bedrooms")
            vc.paramDic.updateValue(self.paramDic["bathrooms"] ?? "", forKey: "bathrooms")
            vc.paramDic.updateValue(self.paramDic["laundry"] ?? "", forKey: "laundry")
            vc.paramDic.updateValue(self.paramDic["parking"] ?? "", forKey: "parking")
            vc.paramDic.updateValue(self.paramDic["description"] ?? "", forKey: "description")
            vc.paramDic.updateValue(self.paramDic["squareFeet"] ?? "", forKey: "squareFeet")
            vc.paramDic.updateValue(self.paramDic["availableOn"] ?? "", forKey: "availableOn")
            vc.paramDic.updateValue(self.paramDic["noSmoking"] ?? "", forKey: "noSmoking")
            vc.paramDic.updateValue(self.paramDic["wheelChairAccess"] ?? "", forKey: "wheelChairAccess")
            vc.paramDic.updateValue(self.paramDic["furnished"] ?? "", forKey: "furnished")
            vc.paramDic.updateValue(self.paramDic["petsAccepted"] ?? "", forKey: "petsAccepted")
            
            vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
            vc.paramDic.updateValue(self.paramDic["housingCategory"] ?? "", forKey: "housingCategory")
        }
        else if housingCategory == "Rooms Wanted"{
            vc.paramDic.updateValue("Housing", forKey: "itemCategory")
            vc.paramDic.updateValue(self.paramDic["description"] ?? "", forKey: "description")
            vc.paramDic.updateValue(self.paramDic["squareFeet"] ?? "", forKey: "squareFeet")
            vc.paramDic.updateValue(self.paramDic["noSmoking"] ?? "", forKey: "noSmoking")
            vc.paramDic.updateValue(self.paramDic["wheelChairAccess"] ?? "", forKey: "wheelChairAccess")
            vc.paramDic.updateValue(self.paramDic["furnished"] ?? "", forKey: "furnished")
            vc.paramDic.updateValue(self.paramDic["petsAccepted"] ?? "", forKey: "petsAccepted")
            vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
            vc.paramDic.updateValue(self.paramDic["housingCategory"] ?? "", forKey: "housingCategory")
        }
        else if housingCategory == "Office & Commercial" || housingCategory == "Parking & Storage"{
            vc.paramDic.updateValue("Housing", forKey: "itemCategory")
             vc.paramDic.updateValue(self.paramDic["description"] ?? "", forKey: "description")
             vc.paramDic.updateValue(self.paramDic["squareFeet"] ?? "", forKey: "squareFeet")
             vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
             vc.paramDic.updateValue(self.paramDic["housingCategory"] ?? "", forKey: "housingCategory")
        }else {
            vc.paramDic.updateValue("Housing", forKey: "itemCategory")
            vc.paramDic.updateValue(self.paramDic["housingType"] ?? "", forKey: "housingType")
            vc.paramDic.updateValue(self.paramDic["bedrooms"] ?? "", forKey: "bedrooms")
            vc.paramDic.updateValue(self.paramDic["bathrooms"] ?? "", forKey: "bathrooms")
            vc.paramDic.updateValue(self.paramDic["laundry"] ?? "", forKey: "laundry")
            vc.paramDic.updateValue(self.paramDic["parking"] ?? "", forKey: "parking")
            vc.paramDic.updateValue(self.paramDic["description"] ?? "", forKey: "description")
            vc.paramDic.updateValue(self.paramDic["squareFeet"] ?? "", forKey: "squareFeet")
            vc.paramDic.updateValue(self.paramDic["availableOn"] ?? "", forKey: "availableOn")
            vc.paramDic.updateValue(self.paramDic["noSmoking"] ?? "", forKey: "noSmoking")
            vc.paramDic.updateValue(self.paramDic["wheelChairAccess"] ?? "", forKey: "wheelChairAccess")
            vc.paramDic.updateValue(self.paramDic["furnished"] ?? "", forKey: "furnished")
            vc.paramDic.updateValue(self.paramDic["petsAccepted"] ?? "", forKey: "petsAccepted")
            
            vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
            vc.paramDic.updateValue(self.paramDic["housingCategory"] ?? "", forKey: "housingCategory")
        }
        
        // New Elemets
        vc.paramDic.updateValue(self.latitude, forKey: "lat")
        vc.paramDic.updateValue(self.longtitude, forKey: "lng")
        let token = SessionManager.shared.fcmToken
        vc.paramDic.updateValue(token, forKey: "token")
        let name = SessionManager.shared.name
        vc.paramDic.updateValue(name, forKey: "name")
        let uid = SessionManager.shared.userId
        vc.paramDic.updateValue(uid, forKey: "uid")
        let image = SessionManager.shared.image
        vc.paramDic.updateValue(image, forKey: "image")
        vc.paramDic.updateValue(self.isoCountryCode, forKey: "country_code")
        vc.paramDic.updateValue(self.city, forKey: "city")
        vc.paramDic.updateValue(self.zipcode, forKey: "zipcode")
        vc.paramDic.updateValue(self.state, forKey: "state")
        
        self.navigationController?.pushViewController(vc, animated: true)

        
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
            if locations.last != nil {
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
                        if let country = placeMark.country {                        print(country)
                            self.country = country
                        }
                        if let state = placeMark.administrativeArea {
                            print(state)
                            self.state = state
                        }
                        if let countryCode = placeMark.isoCountryCode {
                            print(countryCode)
                            self.isoCountryCode = countryCode
                        }
                        self.searchBar.text = "\(self.city),\(self.state) \(self.zipcode)"
                })
                let annotation = MKPointAnnotation()
                annotation.coordinate = locValue
                annotation.title = "Me!"
                annotation.subtitle = "current location"
                mapView.addAnnotation(annotation)
                locationManager.disallowDeferredLocationUpdates()
            }
        }
    }
  override func viewWillAppear(_ animated: Bool) {
        locateMeSwitch.sendActions(for: UIControlEvents.touchUpInside)
  //    .setOn(!swcTemp.isOn, animated: true)
      locateMeSwitch.setOn(true, animated: true)
      
      
    }
}
extension ItemListingLocationVC: MKLocalSearchCompleterDelegate {
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
extension ItemListingLocationVC: UITableViewDataSource ,UITableViewDelegate {
    
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
      self.searchBar.text = completion.title
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            
            self.country = (response?.mapItems[0].placemark.country ?? "" )
            self.city =  (response?.mapItems[0].placemark.locality ?? " " )
            
            self.state = (response?.mapItems[0].placemark.administrativeArea ?? "" )
            
            self.zipcode = (response?.mapItems.last!.placemark.postalCode ?? "")
            
            self.isoCountryCode = (response?.mapItems.last!.placemark.isoCountryCode ?? "")
            
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
