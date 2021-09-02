//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 02.09.2021.
//

import Foundation

class ForecastViewModel {
	let forecast: Forecast.Daily
	
	init(forecast: Forecast.Daily) {
		self.forecast = forecast
	}

	private static var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "E, MMM, d"
		return dateFormatter
	}
	
	private static var numberFormatter: NumberFormatter {
		let numberFormatter = NumberFormatter()
		numberFormatter.maximumFractionDigits = 0
		return numberFormatter
	}
	
	private static var numberPercentFormatter: NumberFormatter {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .percent
		return numberFormatter
	}
	
	var day: String {
		Self.dateFormatter.string(from: forecast.dt)
	}
	
	var overview: String {
		String(describing: forecast.weather.first!.description.capitalized)
	}
	
	var high: String {
		"H: \(Self.numberFormatter.string(for: forecast.temp.max) ?? "0")°"
	}
	
	var low: String {
		"L: \(Self.numberFormatter.string(for: forecast.temp.min) ?? "0")°"
	}
	
	var pop: String {
		"💧: \(Self.numberPercentFormatter.string(for: forecast.temp.min) ?? "0")%"
	}
	
	var clouds: String {
		"☁️: \(forecast.clouds)%"
	}
	
	var humidity: String {
		"Humidity: \(forecast.humidity)%"
	}
}
