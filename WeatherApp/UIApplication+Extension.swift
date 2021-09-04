//
//  UIApplication+Extension.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 04.09.2021.
//

import UIKit

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
