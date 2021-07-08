//
//  PlaceAutoComplete.swift
//  WaterDelivery
//
//  Created by Mayank Sehgal on 23/06/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON


var g_lat: String!
var g_long: String!
var g_address: String!


protocol LocateOnTheMap {
    func locateWithLong(lon: String, andLatitude lat: String, andAddress address: String)
}

class PlaceAutoComplete: UIViewController {

    @IBOutlet weak var placesTBView: UITableView!
    
    //variables
    var placeIDArray = [String]()
    var resultsArray = [String]()
    var primaryAddressArray = [String]()
    var searchResults = [String]()
    var searhPlacesName = [String]()
    let googleAPIKey = "AIzaSyDWK2zFda82S7Dgg0vo1u7ybjpfJcQY6q8"
    var delegate: LocateOnTheMap?
  
    //search Controller implementations
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        setSearchController()
    }
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableViewSetup(){
        self.placesTBView.delegate = self
        self.placesTBView.dataSource = self
        self.placesTBView.tableHeaderView = searchController.searchBar
        self.placesTBView.backgroundColor = UIColor.white
    }
    func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Location"
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForTextSearch(searchText: String){
        placeAutocomplete(text_input: searchText)
        self.placesTBView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.showsCancelButton = true
        self.placesTBView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.placesTBView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }
    func isFiltering() -> Bool{
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBarIsEmpty()){
            searchBar.text = ""
        }else{
            placeAutocomplete(text_input: searchText)
            
        }
    }
    
    //function for autocomplete
    func placeAutocomplete(text_input: String) {
        GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: text_input, filter: nil, sessionToken: nil, callback: { (results, error) -> Void in
            self.placeIDArray.removeAll()
            self.resultsArray.removeAll()
            self.primaryAddressArray.removeAll()
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    //print("primary text: \(result.attributedPrimaryText.string)")
                    //print("Result \(result.attributedFullText) with placeID \(String(describing: result.placeID!))")
                    self.resultsArray.append(result.attributedFullText.string)
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    self.placeIDArray.append(result.placeID)
                }
            }
            self.searchResults = self.resultsArray
            self.searhPlacesName = self.primaryAddressArray
            self.placesTBView.reloadData()
        })
    }
}
extension PlaceAutoComplete: UISearchBarDelegate,  UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForTextSearch(searchText: searchController.searchBar.text!)
    }
    
}
extension PlaceAutoComplete:UITableViewDelegate, UITableViewDataSource {
    
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let correctedAddress = self.resultsArray[indexPath.row].addingPercentEncoding(withAllowedCharacters: .symbols) else {
            print("Error. cannot cast name into String")
            return
        }
        
        //print(correctedAddress)
        let urlString =  "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)&sensor=false&key=\(self.googleAPIKey)"
        
        let url = URL(string: urlString)
        
        Alamofire.request(url!, method: .get, headers: nil)
        .validate()
            .responseJSON { (response) in
                switch response.result {
                case.success(let value):
                    let json = JSON(value)
                    
                    let lat = json["results"][0]["geometry"]["location"]["lat"].rawString()
                    let lng = json["results"][0]["geometry"]["location"]["lng"].rawString()
                    let formattedAddress = json["results"][0]["formatted_address"].rawString()
                    
                    g_lat = lat
                    g_long = lng
                    g_address = formattedAddress
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
                   print(g_lat,g_long,g_address)
                    self.dismiss(animated: true, completion: nil)

                case.failure(let error):
                    print("\(error.localizedDescription)")
                }
 
        }
        
    }
    
}
