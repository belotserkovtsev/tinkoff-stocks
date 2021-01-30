//
//  StocksWorker.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 29.01.2021.
//

import Foundation

class StocksWorker: ObservableObject {
	@Published var stocksData = Stocks()
	
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
	
	func get(for symbol: String, completion: @escaping (Result) -> Void) {
		
		let trimmedSymbol = symbol.trimmingCharacters(in: .whitespaces)
		let baseUrl = "https://cloud.iexapis.com/stable/stock/\(trimmedSymbol)/quote"
		let token = "pk_fbe0000368b54445bab2d3fc6640e23c"
		
		guard let getStockURL = URL(string: "\(baseUrl)?token=\(token)") else {
			completion(.failure(APIError(id: 1, message: "Invalid symbol")))
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
					completion(.failure(APIError(id: 2, message: "Server returned invalid data")))
				}
			} else {
				completion(.failure(APIError(id: 3, message: "Network failure")))
			}
		}
		.resume()
		
	}
	
	//MARK: Methods
}
