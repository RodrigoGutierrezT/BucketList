//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Rodrigo on 18-08-24.
//

import MapKit
import LocalAuthentication
import Foundation


extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        
        var isUnlocked = false
        var alertShown = false
        var alertTitle = "Error"
        var alertMessage = ""
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "new location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(location: Location) {
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
        
        func authenticate() async {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock places."
                
                do {
                    let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                    if success {
                        self.isUnlocked = true
                    }
                } catch( let error) {
                    alertMessage = error.localizedDescription
                    alertShown.toggle()
                }
            } else {
                if let error = error {
                    alertMessage = error.localizedDescription
                    alertShown.toggle()
                }
            }
        }
    }
}
