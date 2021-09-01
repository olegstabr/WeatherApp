//
//  APIService.swift
//  WeatherApp
//
//  Created by Олег Стабровский on 01.09.2021.
//

import Foundation

public class APIService {
	static let shared = APIService()
	
	public enum APIError: Error {
		case error(_ errorString: String)
	}
	
	public func getJSON<T: Decodable>(urlString: String,
				 completion: @escaping (Result<T, APIError>) -> Void) {
		guard let url = URL(string: urlString) else {
			completion(.failure(.error(NSLocalizedString("Error: Invalid URL", comment: ""))))
			return
		}
		let request = URLRequest(url: url)
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				completion(.failure(.error("Error: \(error.localizedDescription)")))
				return
			}
			
			guard let data = data else {
				completion(.failure(.error(NSLocalizedString("Error: Data us corrupt", comment: ""))))
				return
			}
			
			let decoder = JSONDecoder()
			
			do {
				let decodedData = try decoder.decode(T.self, from: data)
				completion(.success(decodedData))
				return
			} catch let decodingError {
				completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
				return
			}
		}.resume()
	}
}
