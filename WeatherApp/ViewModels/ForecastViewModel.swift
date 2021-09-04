//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 02.09.2021.
//

import Foundation

struct ForecastViewModel {
	let forecast: Forecast.Daily
	var system: Int

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
		numberFormatter.maximumFractionDigits = 0
		numberFormatter.numberStyle = .percent
		return numberFormatter
	}
	
	func convert(_ temp: Float) -> Float {
		let celsius = temp - 273.5
		return system == 0 ? celsius : celsius * 9 / 5 + 32
	}
	
	var day: String {
		Self.dateFormatter.string(from: forecast.dt)
	}
	
	var overview: String {
		String(describing: forecast.weather.first!.description.capitalized)
	}
	
	var high: String {
		"H: \(Self.numberFormatter.string(for: convert(forecast.temp.max)) ?? "0")°"
	}
	
	var low: String {
		"L: \(Self.numberFormatter.string(for: convert(forecast.temp.min)) ?? "0")°"
	}
	
	var pop: String {
		"💧: \(Self.numberPercentFormatter.string(for: forecast.pop) ?? "0%")"
	}
	
	var clouds: String {
		"☁️: \(forecast.clouds)%"
	}
	
	var humidity: String {
		"Humidity: \(forecast.humidity)%"
	}
	
	var weatherIconURL: URL {
		let urlString = "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png"
			  return URL(string: urlString)!
		  }
}
