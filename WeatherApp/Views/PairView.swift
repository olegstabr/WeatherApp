//
//  PairView.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 05.09.2021.
//

import SwiftUI

struct PairView: View {
	var leftText: String
	var rightText: String
	
    var body: some View {
		HStack {
			Text("\(leftText): ")
			Text("\(rightText)")
		}
		.font(.title3)
		.padding()
    }
}

struct PairView_Previews: PreviewProvider {
    static var previews: some View {
        PairView(leftText: "123", rightText: "2313")
    }
}
