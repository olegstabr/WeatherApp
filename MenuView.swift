//
//  MenuView.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 07.09.2021.
//

import SwiftUI

struct MenuView: View {
	@EnvironmentObject private var forecastListVM: ForecastListViewModel
	@StateObject private var locationVM = LocationViewModel()
	
    var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Image(systemName: "person")
					.foregroundColor(.gray)
					.imageScale(.large)
				Text("Profile")
					.foregroundColor(.gray)
					.font(.headline)
			}
			.padding(.top, 100)
			HStack {
				Image(systemName: "envelope")
					.foregroundColor(.gray)
					.imageScale(.large)
				Text("Messages")
					.foregroundColor(.gray)
					.font(.headline)
			}
			.padding(.top, 30)
			NavigationLink(destination: TrackingView()) {
				HStack {
					Image(systemName: "location.viewfinder")
						.foregroundColor(.gray)
						.imageScale(.large)
					Text("GPS Info")
						.foregroundColor(.gray)
						.font(.headline)
				}
				.padding(.top, 30)
			}
			Button(action: {
				if let placemark = locationVM.currentPlacemark {
					if let city = placemark.subAdministrativeArea {
						forecastListVM.setLocationAndFetchWeather(location: city)
					}
				}
			}, label: {
				HStack {
					Image(systemName: "location.fill")
						.foregroundColor(.gray)
						.imageScale(.large)
					Text("Current Location")
						.foregroundColor(.gray)
						.font(.headline)
				}
			})
			.padding(.top, 30)
			HStack {
				Image(systemName: "gear")
					.foregroundColor(.gray)
					.imageScale(.large)
				Text("Settings")
					.foregroundColor(.gray)
					.font(.headline)
			}
			.padding(.top, 30)
			Spacer()
		}
		.padding()
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(Color(red: 32/255, green: 32/255, blue: 32/255))
		.edgesIgnoringSafeArea(.all)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
		MenuView()
    }
}
