//
//  TrackingView.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 05.09.2021.
//

import SwiftUI
import CoreLocation

struct TrackingView: View {
	@StateObject var locationViewModel = LocationViewModel()
	
	var body: some View {
		ZStack {
			NavigationView {
				VStack {
					HStack {
						PairView(
							leftText: "Lat",
							rightText: String(format: "%.4f", coordinate?.latitude ?? 0)
						)
						PairView(
						 leftText: "Lng",
						 rightText: String(format: "%.4f", coordinate?.longitude ?? 0)
					 )
					}
					HStack {
						PairView(
							leftText: "Alt",
							rightText: String(format: "%.4f", locationViewModel.lastSeenLocation?.altitude ?? 0)
						)
						PairView(
						 leftText: "Speed",
						 rightText: String(format: "%.2f", locationViewModel.lastSeenLocation?.speed ?? 0)
					 )
					}
					HStack {
						PairView(
							leftText: "Country",
							rightText: locationViewModel.currentPlacemark?.country ?? ""
						)
						PairView(
						 leftText: "City",
						 rightText: locationViewModel.currentPlacemark?.administrativeArea ?? ""
					 )
					}
				}
			}
		}
	}
	
	var coordinate: CLLocationCoordinate2D? {
		locationViewModel.lastSeenLocation?.coordinate
	}
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView()
    }
}
