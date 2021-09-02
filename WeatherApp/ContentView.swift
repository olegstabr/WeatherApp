//
//  ContentView.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 01.09.2021.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
	@State private var location = ""
	@State var forecast: Forecast?
	let dateFormatter = DateFormatter()
	
	init() {
		dateFormatter.dateFormat = "E, MMM, d"
	}
	
    var body: some View {
		NavigationView {
			VStack {
				HStack {
					TextField("Enter location", text: $location)
						.textFieldStyle(RoundedBorderTextFieldStyle())
					Button(action: {
						getWeatherForecast(for: location)
					}, label: {
						Image(systemName: "magnifyingglass.circle")
							.font(.title3)
					})
				}
				if let forecast = forecast {
					List(forecast.daily, id: \.dt) { day in
						VStack(alignment: .leading) {
							Text("\(dateFormatter.string(from: day.dt))")
								.fontWeight(.bold)
							HStack(alignment: .top) {
								Image(systemName: "hourglass")
									.font(.title)
									.frame(width: 50, height: 50)
									.background(RoundedRectangle(cornerRadius: 10)
													.fill(Color.green))
								VStack(alignment: .leading) {
									Text("Description: \(String(describing: day.weather.first!.description.capitalized))")
									Text("High: \(day.temp.max)")
									Text("Low: \(day.temp.min)")
									Text("Humidity: \(day.humidity)")
									Text("Clouds: \(day.clouds)")
									Text("POP: \(day.pop)")
								}
							}
						}
					}
					.listStyle(PlainListStyle())
				} else {
					Spacer()
				}
			}
			.padding(.horizontal)
			.navigationTitle("Weather App")
		}
    }
	
	func getWeatherForecast(for location: String) {
		let apiService = APIService.shared
		CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
			if let error = error {
				print(error.localizedDescription)
			}
			
			if let lat = placemarks?.first?.location?.coordinate.latitude,
			   let lon = placemarks?.first?.location?.coordinate.longitude {
				let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=3863d70f79a9d670d05ef83564bb7648"
				apiService.getJSON(urlString: url) { (result: Result<Forecast, APIService.APIError>) in
							switch result {
							case .success(let forecast):
								self.forecast  = forecast
//								print("Lat: \(forecast.lat)")
//								print("Lon: \(forecast.lon)")
//								print("Timezone: \(forecast.timezone)")
//								for day in forecast.daily {
//									print(dateFormatter.string(from: day.dt))
//									print("  Max: \(day.temp.max)")
//									print("  Min: \(day.temp.min)")
//									print("  Humidity: \(day.humidity)")
//									print("  Description: \(String(describing: day.weather.first!.description))")
//									print("  Clouds: \(day.clouds)")
//									print("  Pop: \(day.pop)")
//									print("  IconURL: \(String(describing: day.weather.first!.weatherIconURL))")
//								}
							case .failure(let apiError):
								switch apiError {
								case .error(let errorString):
									print(errorString)
								}
							}
						}
			}
		}
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
