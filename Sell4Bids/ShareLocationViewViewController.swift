//
//  ShareLocationViewViewController.swift
//  Sell4Bids
//
//  Created by admin on 12/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import GooglePlacesSearchController


class ShareLocationViewViewController: UIViewController,UISearchBarDelegate ,GooglePlacesAutocompleteViewControllerDelegate {
    
    
    
    
    var MainApi = MainSell4BidsApi()
    var share_address : String?
    var selectedOrder = String()
    var selectedmethod = String()
    var selectedItemid = String()
    var lat = Double()
    var long = Double()
    
    @IBAction func Share_Location_Action(_ sender: UIButton) {
        
        
        let cordinates = self.viewGMSMap.myLocation?.coordinate
        if marker.position.latitude == -180 && marker.position.longitude == -180  {
            print("called Api 1 ")
        }else
            
            if marker.position.latitude == -180 && marker.position.longitude == -180 {
                
                lat = cordinates!.latitude
                long = cordinates!.longitude
                
            }else if lat == nil || long == nil {
                print("called Api 2 ")
                lat = marker.position.latitude
                long = marker.position.longitude
            }else{
                print("called Api 3 ")
                
                if selectedmethod == "Orders" {
                    MainApi.Share_Location_Api(address: share_address ?? " " , itemId: selectedItemid, orderId: selectedOrder, lat: self.lat, lng: self.long) { (status, data, error) in
                        
                        print("Status == \(status)")
                        print("data == \(data)")
                        print("error == \(error)")
                        
                        
                    }
                }else if selectedmethod == "Offers" {
                    MainApi.Share_Location_Api(address: share_address ?? " " , itemId: selectedItemid, orderId: selectedOrder, lat: self.lat, lng: self.long) { (status, data, error) in
                        
                        print("Status == \(status)")
                        print("data == \(data)")
                        print("error == \(error)")
                        
                        
                    }
                }
                
        }
        
    }
    
    @IBOutlet weak var ShareLocationbtn: UIButton!
    
    
    func getAutocompletePicker() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    var marker = GMSMarker()
    
    @IBOutlet weak var viewGMSMap: GMSMapView!
    
    var userPickedThePlace : GMSPlace?
    var usersLocation : CLLocation?
    private let locationManager = CLLocationManager()
    var flagPermissionGranted = true
    let GoogleMapsAPIServerKey = "AIzaSyAWZYqghSlhhow9cLhRAGh5WQ0DBgBbWmA"
    
    @IBOutlet weak var Select_location_btn: UIButton!
    lazy var placesSearchController: GooglePlacesSearchController = {
        let controller = GooglePlacesSearchController(delegate: self,
                                                      apiKey: GoogleMapsAPIServerKey,
                                                      placeType: .address
            // Optional: coordinate: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423),
            // Optional: radius: 10,
            // Optional: strictBounds: true,
            // Optional: searchBarPlaceholder: "Start typing..."
        )
        controller.searchBar.isTranslucent = true
        controller.searchBar.barStyle = .black
        controller.searchBar.tintColor = .white
        controller.searchBar.barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
        return controller
    }()
    
    func viewController(didAutocompleteWith place: PlaceDetails) {
        
        print("Place Details ========= \(place.formattedAddress)")
        self.share_address = String(place.formattedAddress)
        self.lat = Double((place.coordinate?.longitude)!)
        self.long = Double((place.coordinate?.latitude)!)
        print("lat ==\(lat) , long ==\(long) , share ==\(share_address)" )
        viewGMSMap.camera = GMSCameraPosition(target: place.coordinate!, zoom: 15, bearing: 0, viewingAngle: 0)
        viewGMSMap.isMyLocationEnabled = true
        viewGMSMap.settings.compassButton = true
        viewGMSMap.settings.myLocationButton = true
        
        
        
        marker.title = place.formattedAddress
        self.share_address = place.formattedAddress
        marker.map = viewGMSMap
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func searchlocationbtn(_ sender: Any) {
        marker.map?.clear()
        getAutocompletePicker()
        //    placesSearchController.view.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 40)
        //        self.present(placesSearchController, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        ShareLocationbtn.addShadowAndRound()
        viewGMSMap.isMyLocationEnabled = true
        viewGMSMap.settings.myLocationButton = true
        Select_location_btn.layer.cornerRadius = 8
        
        viewGMSMap.isMyLocationEnabled = true
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString("34sdfsdf") { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                
                
                
                else {
                    // handle no location found
                    return
            }
            
            for address in placemarks {
                //print(address.addressDictionary!["Formatted Address"])
                
                
                
                
                
            }
            self.viewGMSMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 4, bearing: 0, viewingAngle: 0)
            self.viewGMSMap.animate(toZoom: 15)
            self.viewGMSMap.isMyLocationEnabled = true
            self.viewGMSMap.settings.compassButton = true
            self.viewGMSMap.settings.myLocationButton = true
        }
    }
    
    
    
    private func presentPlacePickerVC(location: CLLocation?) {
        var bounds = GMSCoordinateBounds()
        if let location = usersLocation {
            //bounds.
            print("using users location on place picker view controller")
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let viewport = GMSCoordinateBounds(coordinate: center, coordinate: center)
            bounds = viewport
            
        }else {
            //            //we have not users location so use default
            //            print("Could not get users location because not permission. so present a place picker with hard coded location")
            //            let center = CLLocationCoordinate2D(latitude: 37.788204, longitude: -122.411937)
            //            let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
            //            //let northEas = CLLocationCoordinate2D(
            //            let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
            //
            //            let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            //            bounds = viewport
        }
        
        let gmsPlaceConfig = GMSPlacePickerConfig.init(viewport: bounds)
        let placePickerVC = GMSPlacePickerViewController(config: gmsPlaceConfig)
        placePickerVC.delegate = self
        self.present(placePickerVC, animated: false, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension ShareLocationViewViewController : GMSPlacePickerViewControllerDelegate {
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        print("did pick a place")
        self.userPickedThePlace = place
        //place.name
        if let address = place.formattedAddress {
            self.share_address = address
        }
        
        viewGMSMap.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        viewGMSMap.isMyLocationEnabled = true
        viewGMSMap.settings.compassButton = true
        viewGMSMap.settings.myLocationButton = true
        let marker = GMSMarker(position: place.coordinate)
        marker.title = place.formattedAddress
        marker.map = viewGMSMap
        self.dismiss(animated: true, completion: nil)
        
    }
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        print("GMSPlacePickerViewController did fail with error")
        self.alert(message: "Sorry, we could not pick a place. ")
        
    }
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        print("GMSPlacePickerViewController did cancel")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}

extension ShareLocationViewViewController : CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            self.flagPermissionGranted = false
            //show map with hard coded location
            presentPlacePickerVC(location: usersLocation)
            return
        }
        // 4
        self.flagPermissionGranted = true
        locationManager.startUpdatingLocation()
        
        
        //5
        //mapView.isMyLocationEnabled = true
        //mapView.settings.myLocationButton = true
    }
    
    
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        usersLocation = location
        
        //present a placePickerViewController with location set as users Location
        presentPlacePickerVC(location: location)
        locationManager.stopUpdatingLocation()
        
    }
}

extension ShareLocationViewViewController : GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place Details = \(place)")
        self.share_address = place.formattedAddress
        self.lat = Double((place.coordinate.longitude))
        self.long = Double((place.coordinate.latitude))
        print("lat ==\(lat) , long ==\(long) , share ==\(share_address)" )
        viewGMSMap.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        viewGMSMap.isMyLocationEnabled = true
        viewGMSMap.settings.compassButton = true
        viewGMSMap.settings.myLocationButton = true
        marker = GMSMarker(position: place.coordinate)
        marker.title = place.formattedAddress
        marker.map = viewGMSMap
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


