//
//  HomeViewModel.swift
//  Food Ordering App
//
//  Created by KhaleD HuSsien on 19/12/2022.
//

import SwiftUI
import CoreLocation
class HomeViewModel: NSObject,ObservableObject,CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    // Location Details...
    @Published var userLocation: CLLocation!
    @Published var userAddress = ""
    @Published var noLocation: Bool = false
    // menu
    @Published var showMenu = false
    
    // Functions
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
}
