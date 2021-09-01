//
//  ContentView.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 01.09.2021.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
		json()
    }
	
	func json() -> some View {
		let apiService = APIService.shared
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "E, MMM, d"
		CLGeocoder().geocodeAddressString("Novosibirsk") { (placemarks, error) in
			if let error = error {
				print(error.localizedDescription)
			}
			
			if let lat = placemarks?.first?.location?.coordinate.latitude,
			   let lon = placemarks?.first?.location?.coordinate.longitude {
				let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=3863d70f79a9d670d05ef83564bb7648"
				apiService.getJSON(urlString: url) { (result: Result<Forecast, APIService.APIError>) in
							switch result {
							case .success(let forecast):
								print("Lat: \(forecast.lat)")
								print("Lon: \(forecast.lon)")
								print("Timezone: \(forecast.timezone)")
								for day in forecast.daily {
									print(dateFormatter.string(from: day.dt))
									print("  Max: \(day.temp.max)")
									print("  Min: \(day.temp.min)")
									print("  Humidity: \(day.humidity)")
									print("  Description: \(String(describing: day.weather.first!.description))")
									print("  Clouds: \(day.clouds)")
									print("  Pop: \(day.pop)")
									print("  IconURL: \(String(describing: day.weather.first!.weatherIconURL))")
								}
							case .failure(let apiError):
								switch apiError {
								case .error(let errorString):
									print(errorString)
								}
							}
						}
			}
		}
		return Text("")
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
