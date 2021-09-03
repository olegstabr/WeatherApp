//
//  Forecast.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 01.09.2021.
//

import Foundation

struct Forecast: Codable {
	struct Daily: Codable {
		struct Temp: Codable {
			let day: Float
			let min: Float
			let max: Float
			let night: Float
			let eve: Float
			let morn: Float
		}
		struct FeelsLike: Codable {
			let day: Float
			let night: Float
			let eve: Float
			let morn: Float
		}
		struct Weather: Codable {
			let id: Int
			let main: String
			let description: String
			let icon: String
		}
		let dt: Date
		let sunrise: Date
		let sunset: Date
		let moonrise: Date
		let moonset: Date
		let moonphase: Float?
		let temp: Temp
		let feels_like: FeelsLike
		let pressure: Int
		let humidity: Int
		let dew_point: Float
		let wind_speed: Float
		let wind_deg: Int
		let wind_gust: Float
		let weather: [Weather]
		let clouds: Int
		let pop: Float
		let rain: Float?
		let uvi: Float
	}
	let lat: Float
	let lon: Float
	let timezone: String
	let timezone_offset: Int
	let daily: [Daily]
}
