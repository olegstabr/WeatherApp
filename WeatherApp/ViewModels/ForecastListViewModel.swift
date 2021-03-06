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
	struct AppError: Identifiable {
		let id = UUID().uuidString
		let errorString: String
	}
	
	var appError: AppError?
	@Published var forecasts: [ForecastViewModel] = []
	@Published var isLoading = false
	@Published var location = ""
	@Published var isNeedToFetchWeather = false
	@AppStorage("location") var storageLocation = ""
	@AppStorage("system") var system = 0 {
		didSet {
			for i in 0..<forecasts.count {
				forecasts[i].system = system
			}
		}
	}
	
	init() {
		location = storageLocation
		getWeatherForecast()
	}
	
	func setLocationAndFetchWeather(location: String) {
		self.location = location
		getWeatherForecast()
	}
	
	func getWeatherForecast() {
		storageLocation = location
		UIApplication.shared.endEditing()
		
		if location.isEmpty {
			forecasts = []
		} else {
			isLoading = true
			let apiService = APIServiceCombine.shared
			CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
				if let error = error as? CLError {
					switch error.code {
					case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
						self.appError = AppError(errorString: NSLocalizedString("Unable to determine location from this text.", comment: ""))
					case .network:
						self.appError = AppError(errorString: NSLocalizedString("You don`t appear to have a network connection.", comment: ""))
					default:
						self.appError = AppError(errorString: error.localizedDescription)
					}
					
					self.isLoading = false
					print(error.localizedDescription)
				}
				
				if let lat = placemarks?.first?.location?.coordinate.latitude,
				   let lon = placemarks?.first?.location?.coordinate.longitude {
					let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=3863d70f79a9d670d05ef83564bb7648"
					apiService.getJSON(urlString: url) { (result: Result<Forecast, APIServiceCombine.APIError>) in
						switch result {
						case .success(let forecast):
							DispatchQueue.main.async {
								self.isLoading = false
								self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system) }
							}
						case .failure(let apiError):
							switch apiError {
							case .error(let errorString):
								self.isLoading = false
								self.appError = AppError(errorString: errorString)
								print(errorString)
							}
						}
					}
				}
			}
		}
	}
}
