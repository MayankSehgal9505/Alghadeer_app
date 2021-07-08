//
//  MapVC.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 23/06/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
class MapVC: UIViewController {
    //MARK:- IBOutlet
    @IBOutlet weak var mapView: GMSMapView!
    
    //MARK:- Variables
    private var observerAdded = false
    private let locationManager: CLLocationManager? = CLLocationManager()
    private var gmsView: GMSMapView?
    private var currentLocation = CLLocationCoordinate2D.init()
    private var tableView: UITableView!
    private var tableDataSource: GMSAutocompleteTableDataSource!
    var searchResults = [String]()

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actionOnViewWillAppear()
    }
    //MARK:- Internal Methods
    private func actionOnViewWillAppear() {
        if (!observerAdded) {
            observerAdded = true
            NotificationCenter.default.addObserver(self, selector: #selector(setLocationManager), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
        // add observer only if not already added for app comes in foreground
    }
    
    /// setup location manager
    @objc private func setLocationManager() {
        // if location services enable check for status
        if CLLocationManager.locationServicesEnabled() {
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            switch status {
            case .notDetermined:
                locationManager?.requestWhenInUseAuthorization()
            case .denied,.restricted:
                showLocationAlert()
            default:
                break
            }
        } else {
            showLocationAlert()
        }
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 10
        locationManager?.startUpdatingLocation()
    }
    
    /// setup Map view
    private func setupMapView(currentLocation: CLLocationCoordinate2D) {
        gmsView?.clear()
        gmsView?.removeFromSuperview()
        gmsView = setupMapView(masterLat: currentLocation.latitude, masterLong: currentLocation.longitude
            , zoom: Float(17.0), width: self.mapView.frame.size.width, height: self.mapView.frame.size.height)
        setAnimatedSingleMarker(mapViewObject: gmsView!,coordinates:currentLocation)
        self.mapView.addSubview(gmsView!)
    }

    /// Set map view with current device Lat/Long 7 zoom value
    ///
    /// - Parameters:
    ///   - lat: latitude value
    ///   - long: longitude value
    ///   - zoom: zoom value
    /// - Returns: return instance of uiview
    func setupMapView(masterLat:Double, masterLong:Double, zoom:Float,width:CGFloat, height:CGFloat) -> GMSMapView {
        // Create a GMSCameraPosition that tells the map to display
        let camera = GMSCameraPosition.camera(withLatitude: masterLat, longitude: masterLong, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0.0, y: 0.0, width: width, height: height), camera: camera)
        return mapView
    }
    
    /// show location alert
    private func showLocationAlert(){
        let alertController = UIAlertController (title: "", message: "Enable location permission for app to find current location.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            let app = UIApplication.shared
            if #available(iOS 10.0, *) {
                app.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                app.openURL(URL(string:UIApplication.openSettingsURLString)!)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    /// set animated marker for current location
    ///
    /// - Parameters:
    ///   - mapViewObject: map object
    ///   - coordinates: coordinated of device
    func setAnimatedSingleMarker(mapViewObject:GMSMapView,coordinates:CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinates)
        let pulseView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 40, height: 40))
        pulseView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        let pulseRingImg = UIImageView(frame: CGRect(x: -30, y: -30, width: 10, height: 10))
        pulseRingImg.image = UIImage(named: "iconBlueDot")
        pulseRingImg.center = pulseView.center
        pulseView.addSubview(pulseRingImg)
        pulseView.makeCircularView(withBorderColor: UIColor.blue, withBorderWidth: 1.0, withCustomCornerRadiusRequired: true, withCustomCornerRadius: 20)
        marker.iconView = pulseView
        marker.map = mapViewObject
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    }
    //MARK:- IBActions
    @IBAction func location(_ sender: UIButton) {
        let placeVC = PlaceAutoComplete.init()
        placeVC.modalPresentationStyle = .fullScreen
        self.present(placeVC, animated: true, completion: nil)

    }
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CoreLocation Delegate Methods
extension MapVC:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            self.currentLocation = currentLocation
            setupMapView(currentLocation: self.currentLocation)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        currentLocation = userLocation.coordinate
        setupMapView(currentLocation: currentLocation)
    }
}

// MARK: - CoreLocation Delegate Methods
extension MapVC:UITableViewDataSource,UITableViewDelegate {
    //Table view methods to be implemented
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        

        return cell
    }
    
}
