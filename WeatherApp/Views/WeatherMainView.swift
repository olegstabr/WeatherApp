//
//  WeatherMainView.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 01.09.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct WeatherMainView: View {
	@StateObject private var forecastListVM = ForecastListViewModel()
	@StateObject private var locationVM = LocationViewModel()
	
    var body: some View {
		ZStack {
			NavigationView {
				VStack {
					Button(action: {
						if let placemark = locationVM.currentPlacemark {
							if let city = placemark.subAdministrativeArea {
								forecastListVM.location = city
							}
						}
					}, label: {
						RoundedRectangle(cornerRadius: 5)
							.frame(height: 60)
							.foregroundColor(.gray)
							.overlay(Text("Локация").foregroundColor(.black).font(.largeTitle))
					})
					Picker(selection: $forecastListVM.system, label: Text("System")) {
						Text("°C").tag(0)
						Text("°F").tag(1)
					}
					.pickerStyle(SegmentedPickerStyle())
					.frame(width: 200)
					.padding(.vertical)
					HStack {
						TextField("Enter location", text: $forecastListVM.location,
								  onCommit: {
									forecastListVM.getWeatherForecast()
								  })
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.overlay(
								Button(action: {
									forecastListVM.location = ""
									forecastListVM.getWeatherForecast()
								}) {
									Image(systemName: "xmark.circle")
										.foregroundColor(.gray)
								}
								.padding(.horizontal),
								alignment: .trailing
							)
						Button(action: {
							forecastListVM.getWeatherForecast()
						}, label: {
							Image(systemName: "magnifyingglass.circle")
								.font(.title3)
						})
					}
					List(forecastListVM.forecasts, id: \.day) { day in
						VStack(alignment: .leading) {
							Text("\(day.day)")
								.fontWeight(.bold)
							HStack(alignment: .center) {
								WebImage(url: day.weatherIconURL)
									.resizable()
									.placeholder {
										Image(systemName: "hourglass")
									}
									.scaledToFit()
									.frame(width: 100)
								VStack(alignment: .leading) {
									Text("\(day.overview)")
										.font(.title2)
									HStack {
										Text("\(day.high)")
										Text("\(day.low)")
									}
									HStack {
										Text("\(day.clouds)")
										Text("\(day.pop)")
									}
									Text("\(day.humidity)")
								}
							}
						}
					}
					.listStyle(PlainListStyle())
				}
				.padding(.horizontal)
				.navigationTitle("Oleg Weather")
				.alert(item: $forecastListVM.appError) { appAlert in
					Alert(title: Text("Error"), message: Text("""
						\(appAlert.errorString)
						Please try again later
						"""
						))
				}
			}
			if forecastListVM.isLoading {
				ZStack {
					Color(.white)
						.opacity(0.5)
						.ignoresSafeArea()
					ProgressView("Fetching Weather")
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 10)
								.fill(Color(.systemBackground))
						)
						.shadow(radius: 10)
				}
			}
		}
		.onAppear {
			locationVM.requestPermission()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView()
    }
}
