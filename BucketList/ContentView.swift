//
//  ContentView.swift
//  BucketList
//
//  Created by Rodrigo on 16-08-24.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var viewModel = ViewModel()
    @State private var toggleStyle = false
    @State private var style: MapStyle = .standard
    
    var body: some View {
        
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                                .onLongPressGesture {
                                    viewModel.selectedPlace = location
                                }
                        }
                    }
                }
                .mapStyle(style)
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) {
                        viewModel.updateLocation(location: $0)
                    }
                }
            }
            
            HStack {
                Button(toggleStyle ? "Standard mode" : "Hybrid mode") {
                    style = toggleStyle ? .standard : .hybrid
                    toggleStyle.toggle()
                }
            }
            
        } else {
            Button("Unlock device") {
                Task {
                    await viewModel.authenticate()
                }
            }
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(.capsule)
            .alert(isPresented: $viewModel.alertShown) {
                Alert(
                    title: Text("Auth Failed"),
                    message: Text("Failed on Biometric authentication")
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
