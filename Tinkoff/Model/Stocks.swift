//
//  Stocks.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 29.01.2021.
//

import Foundation

struct Stocks {
	private(set) var lastRequestedStock: (StockData, URL)?
	private(set) var favorites = [(StockData, URL)]()
	
	mutating func addCurrentStockToFavourite() {
		if !favorites.contains(where: { lastRequestedStock!.0.symbol == $0.0.symbol }) {
			favorites.append(lastRequestedStock!)
		}
	}
	
	mutating func setLastRequestedStock(_ stock: StockData, with link: URL) {
		lastRequestedStock = (stock, link)
	}
	
	mutating func updateFavourite(with stock: StockData) {
		if let i = favorites.firstIndex(where: { $0.0.symbol == stock.symbol }) {
			favorites[i].0 = stock
		}
	}
}
