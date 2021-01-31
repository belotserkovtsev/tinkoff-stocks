//
//  StocksWorker.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 29.01.2021.
//

import Foundation

class StocksWorker: ObservableObject {
	@Published private(set) var stocksData = Stocks()
	
	var stockToDisplay: StockData? {
		stocksData.lastRequestedStock?.0
	}
	
	var favourites: [StockData] {
		stocksData.favorites.map { $0.0 }
	}
	
	//MARK: Intents
	
	func addCurrentStockToFavourite() {
		stocksData.addCurrentStockToFavourite()
	}
	
	func updateFavourites(completion: @escaping (Result) -> Void) {
		if stocksData.favorites.isEmpty {
			completion(.failure(APIError(id: 5, message: "Nothing to refresh")))
		}
		for i in stocksData.favorites.indices {
			let symbol = stocksData.favorites[i].0.symbol
			var stockRequest = URLRequest(url: stocksData.favorites[i].1)
			stockRequest.httpMethod = "GET"
			stockRequest.timeoutInterval = 5
			let session = URLSession.shared
			
			session.dataTask(with: stockRequest) { (data, response, error) in
				if let httpResponse = response as? HTTPURLResponse {
					print(httpResponse.statusCode)
					
					if httpResponse.statusCode == 404 {
						completion(.failure(APIError(id: 404, message: "Could not find any data for \(symbol)")))
						return
					} else if httpResponse.statusCode != 200 {
						completion(.failure(APIError(id: 500, message: "Internal server error. Try again later")))
						return
					}
				}
				
				if let rawData = data {
					do {
						let resp: StockData = try JSONDecoder()
							.decode(StockData.self, from: rawData)
						print(resp)
						DispatchQueue.main.async {
							self.stocksData.updateFavourite(with: resp)
							completion(.success)
						}
					} catch {
						completion(.failure(APIError(id: 3, message: "Server returned unexpected data")))
						return
					}
				} else {
					completion(.failure(APIError(id: 4, message: "Network failure")))
					return
				}
			}
			.resume()
		}
	}
	
	func getStock(for symbol: String, completion: @escaping (Result) -> Void) {
		
		let trimmedSymbol = symbol.trimmingCharacters(in: .whitespaces)
		if trimmedSymbol.isEmpty {
			completion(.failure(APIError(id: 1, message: "Empty request")))
			return
		}
		let baseUrl = "https://cloud.iexapis.com/stable/stock/\(trimmedSymbol)/quote"
		let token = "pk_fbe0000368b54445bab2d3fc6640e23c"
		
		guard let getStockURL = URL(string: "\(baseUrl)?token=\(token)") else {
			completion(.failure(APIError(id: 2, message: "Invalid symbol")))
			return
		}
		
		var stockRequest = URLRequest(url: getStockURL)
		stockRequest.httpMethod = "GET"
		stockRequest.timeoutInterval = 5
		let session = URLSession.shared
		
		session.dataTask(with: stockRequest) { (data, response, error) in
			if let httpResponse = response as? HTTPURLResponse {
				print(httpResponse.statusCode)
				
				if httpResponse.statusCode == 404 {
					completion(.failure(APIError(id: 404, message: "Could not find any data for \(symbol)")))
					return
				} else if httpResponse.statusCode != 200 {
					completion(.failure(APIError(id: 500, message: "Internal server error. Try again later")))
					return
				}
			}
			
			if let rawData = data {
				do {
					let resp: StockData = try JSONDecoder().decode(StockData.self, from: rawData)
					print(resp)
					DispatchQueue.main.async {
						self.stocksData.setLastRequestedStock(resp, with: getStockURL)
						completion(.success)
					}
				} catch {
					completion(.failure(APIError(id: 3, message: "Server returned unexpected data")))
					return
				}
			} else {
				completion(.failure(APIError(id: 4, message: "Network failure")))
				return
			}
		}
		.resume()
		
	}
}
