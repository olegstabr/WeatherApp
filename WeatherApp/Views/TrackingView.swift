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
		VStack {
			VStack {
				PairView(
					leftText: "Latitude",
					rightText: String(coordinate?.latitude ?? 0)
				)
				PairView(
					leftText: "Longitude",
					rightText: String(coordinate?.longitude ?? 0)
				)
				PairView(
					leftText: "Altitude",
					rightText: String(locationViewModel.lastSeenLocation?.altitude ?? 0)
				)
				PairView(
					leftText: "Speed",
					rightText: String(locationViewModel.lastSeenLocation?.speed ?? 0)
				)
				PairView(
					leftText: "Country",
					rightText: locationViewModel.currentPlacemark?.country ?? ""
				)
				PairView(leftText: "City", rightText: locationViewModel.currentPlacemark?.administrativeArea ?? ""
				)
			}
			.padding()
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
