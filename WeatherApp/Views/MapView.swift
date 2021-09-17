//
//  MapView.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 17.09.2021.
//

import SwiftUI
import MapKit

struct MapView: View {
	var coordinate: CLLocationCoordinate2D
	@State var trackingMode = MapUserTrackingMode.follow
	@State private var region =
		MKCoordinateRegion(
			center: MapConstants.novosibirksCoords,
			span: MKCoordinateSpan(
				latitudeDelta: MapConstants.latitudeDelta,
				longitudeDelta: MapConstants.longitudeDelta
			)
		)
    var body: some View {
		Map(coordinateRegion: $region,
			interactionModes: .all,
			showsUserLocation: true,
			userTrackingMode: $trackingMode)
			.onAppear {
				setRegion(coordinate)
			}
		Spacer()
		Button(action: {
			changeUserTrackingMode()
		}, label: {
			Image(systemName: "location")
				.imageScale(.large)
				.padding(.vertical, 30)
				.frame(width: 70)
		})
    }
	
	private func changeUserTrackingMode() {
		switch trackingMode {
		case .follow:
			trackingMode = .none
		case .none:
			trackingMode = .follow
		default:
			fatalError()
		}
	}
	
	private func setRegion(_ coordinate: CLLocationCoordinate2D) {
		region =
			MKCoordinateRegion(
				center: CLLocationCoordinate2D(
					latitude: coordinate.latitude,
					longitude: coordinate.latitude
				),
				span: MKCoordinateSpan(
					latitudeDelta: MapConstants.latitudeDelta,
					longitudeDelta: MapConstants.longitudeDelta
				)
			)
	}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
		MapView(coordinate: MapConstants.novosibirksCoords)
    }
}

public struct MapConstants {
	static let latitudeDelta = 0.2
	static let longitudeDelta = 0.2
	static let novosibirksCoords = CLLocationCoordinate2D(latitude: 55.032_573, longitude: 82.927_787)
}

