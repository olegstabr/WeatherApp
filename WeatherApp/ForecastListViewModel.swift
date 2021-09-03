//
//  ForecastListViewModel.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 02.09.2021.
//

import Foundation
import CoreLocation
import SwiftUI

class ForecastListViewModel: ObservableObject {
	@Published var forecasts: [ForecastViewModel] = []
	@AppStorage("location") var location = ""
	@AppStorage("system") var system = 0 {
		didSet {
			for i in 0..<forecasts.count {
				forecasts[i].system = system
			}
		}
	}
	
	init() {
		if !location.isEmpty {
			getWeatherForecast()
		}
	}
	
	func getWeatherForecast() {
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
								DispatchQueue.main.async {
									self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system) }
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
	}
}
