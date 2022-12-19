//
//  HomeViewModel.swift
//  Food Ordering App
//
//  Created by KhaleD HuSsien on 19/12/2022.
//

import SwiftUI
import CoreLocation
import Firebase
class HomeViewModel: NSObject,ObservableObject,CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    // Location Details...
    @Published var userLocation: CLLocation!
    @Published var userAddress = ""
    @Published var noLocation: Bool = false
    // menu
    @Published var showMenu = false
    //items data...
    @Published var items: [Item] = []
    @Published var filtered: [Item] = []
    
    
    //MARK: - Functions
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // checking location access...
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false
            // Direct call...
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // reading user location and extract details...
        self.userLocation = locations.last
        self.extractLocation()
        // after extracting location login...
        self.login()
    }
    func extractLocation(){
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { res, error in
            guard let safeData = res else{return}
            var address = ""
            // getting area and location name...
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            self.userAddress = address
        }
    }
    // anynoums login for reading db
    func login(){
        Auth.auth().signInAnonymously { res, error in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            guard let result = res else{return}
            print("Success \(result.user.uid)")
            //Fetching after login...
            self.fetchData()
        }
    }
    // Fetching item Data...
    func fetchData(){
        let db = Firestore.firestore()
        db.collection("Items").getDocuments { snap, error in
            guard let itemData = snap else{return}
            self.items = itemData.documents.compactMap({ (doc)-> Item? in
                let id = doc.documentID
                let name = doc.get("item_name")as! String
                let cost = doc.get("item_cost")as! NSNumber
                let ratings = doc.get("item_ratings")as! String
                let image = doc.get("item_image")as! String
                let details = doc.get("item_details")as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
            })
            self.filtered = self.items
        }
    }
    // filter data...
    func filterData(){
        withAnimation(.default, {
            self.filtered = self.items.filter({
                return $0.item_name.lowercased().contains(self.search.lowercased())
            })
        })
    }
}
