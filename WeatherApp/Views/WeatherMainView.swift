//
//  WeatherMainView.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 01.09.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct WeatherMainView: View {
	@State var isMenuShow = false
	@StateObject var forecastListVM = ForecastListViewModel()
	
	var body: some View {
		let drag = DragGesture()
		 .onEnded {
			 if $0.translation.width < 100 {
				 withAnimation {
					 self.isMenuShow = false
				 }
			} else {
				withAnimation {
					self.isMenuShow = true
				}
			}
		 }
		
		NavigationView {
			GeometryReader { geometry in
				ZStack(alignment: .leading) {
					MainView(isMenuShow: self.$isMenuShow)
						.frame(width: geometry.size.width, height: geometry.size.height)
						.offset(x: self.isMenuShow ? 7 * geometry.size.width / 10 : 0)
						.disabled(self.isMenuShow)
						.environmentObject(forecastListVM)
					if isMenuShow {
						MenuView()
							.frame(width: 7 * geometry.size.width / 10)
							.transition(.move(edge: .leading))
							.environmentObject(forecastListVM)
					}
				}
				.gesture(drag)
			}
			.navigationBarItems(leading: (
				Button(action: {
					withAnimation {
						self.isMenuShow.toggle()
					}
				}, label: {
					Image(systemName: "line.horizontal.3")
						.imageScale(.large)
				})
			))
		}
	}
}

struct MainView: View {
	@EnvironmentObject private var forecastListVM: ForecastListViewModel
	@StateObject private var locationVM = LocationViewModel()
	@Binding var isMenuShow: Bool
	
	var body: some View {
		ZStack(alignment: .leading) {
			VStack {
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
								forecastListVM.setLocationAndFetchWeather(location: "")
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
				.padding(.horizontal)
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
