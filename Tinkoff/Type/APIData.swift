//
//  APIData.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 30.01.2021.
//

import Foundation

struct StockData: Codable, Hashable {
	var symbol: String
	var companyName: String
	var latestPrice: Double
	var change: Double
}

struct APIError: Codable {
	var id: Int
	var message: String
}
