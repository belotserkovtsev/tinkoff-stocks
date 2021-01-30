//
//  Stocks.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 29.01.2021.
//

import Foundation

struct Stocks {
	var lastRequestedStock: (StockData, URL)?
	var favorites = [(StockData, URL)]()
	
	mutating func addCurrentStockToFavourite() {
		if !favorites.contains(where: { lastRequestedStock!.0.symbol == $0.0.symbol }) {
			favorites.append(lastRequestedStock!)
		}
	}
	
	mutating func setLastRequestedStock(_ stock: StockData, with link: URL) {
		lastRequestedStock = (stock, link)
	}
}
