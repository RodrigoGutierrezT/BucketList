//
//  MapKitView2.swift
//  BucketList
//
//  Created by Rodrigo on 17-08-24.
//

import MapKit
import SwiftUI

struct LocationTest: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapKitView2: View {
    let locations = [
        LocationTest(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        LocationTest(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]
    
    var body: some View {
        VStack {
            Map {
                ForEach(locations) { location in
                    //Marker with default behavior
                    //Marker(location.name, coordinate: location.coordinate)
                    
                    Annotation(location.name, coordinate: location.coordinate) {
                        Text(location.name)
                            .font(.headline)
                            .padding()
                            .background(.blue.gradient)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                    .annotationTitles(.hidden)
                }
            }
        }
    }
}

#Preview {
    MapKitView2()
}
