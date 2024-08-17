//
//  MapKitTapView.swift
//  BucketList
//
//  Created by Rodrigo on 17-08-24.
//

import MapKit
import SwiftUI

struct MapKitTapView: View {
    var body: some View {
        VStack {
            MapReader { proxy in
                Map()
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            print(coordinate)
                        }
                    }
            }
        }
    }
}

#Preview {
    MapKitTapView()
}
