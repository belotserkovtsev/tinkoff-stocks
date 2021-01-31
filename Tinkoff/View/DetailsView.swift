//
//  DetailsView.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 30.01.2021.
//

import SwiftUI

struct DetailsView: View {
	@ObservedObject var stocks: StocksWorker
	
	var body: some View {
		if let data = stocks.stockToDisplay {
			VStack(spacing: .zero) {
				companyDescriptionView(for: data)
					.padding(.bottom)
				
				stockPriceView(for: data)
					.padding(.bottom, 44)
				
				Button(action: {
					stocks.addCurrentStockToFavourite()
				}, label: { Text("Add to favorite") })
				
				Spacer()
			}
			.padding(.top, 36)
		} else {
			EmptyView()
		}
		
	}
	
	//MARK: DetailsView UI Elements
	
	private func companyDescriptionView(for data: StockData) -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(Color("card"))
			VStack(alignment: .leading, spacing: .zero) {
				Text("Company")
					.font(.system(size: 14, weight: .regular))
					.padding(.bottom, 6)
				Text(data.companyName)
					.font(.system(size: 16, weight: .regular))
					.foregroundColor(Color("darkGray2"))
					.padding(.bottom, 14)
				Divider()
					.font(.system(size: 14, weight: .regular))
					.padding(.bottom, 14)
				Text("Ticker/Symbol")
					.font(.system(size: 14, weight: .regular))
					.padding(.bottom, 6)
				Text(data.symbol)
					.font(.system(size: 16, weight: .regular))
					.foregroundColor(Color("darkGray2"))
			}.padding(.leading, 16)
		}
		
		.frame(width: companyDescriptionWidth, height: commpanyDescriptionHeight)
		.shadow(color: Color("shadow"), radius: 8, x: 2, y: 2)
	}
	
	private func stockPriceView(for data: StockData) -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(Color("card"))
			VStack(alignment: .leading, spacing: .zero) {
				Text("$ \(String(format: "%.2f", data.latestPrice))")
					.font(.system(size: 44, weight: .regular))
					.padding(.bottom, 16)
				HStack {
					Image(systemName: data.change >= 0 ? "arrow.up" : "arrow.down")
						.resizable()
						.foregroundColor(Color("darkGray2"))
						.aspectRatio(contentMode: .fit)
						.frame(width: 16, height: 16)
					
					Text("\(String(format: "%.2f", data.change)) %")
						.foregroundColor(Color("darkGray2"))
						.font(.system(size: 16, weight: .medium))
					Text(sinceWhen)
						.font(.system(size: 16, weight: .light))
						.opacity(0.6)
					Spacer()
				}
			}.padding(.leading, 17)
		}
		.frame(width: stockPriceWidth, height: stockPriceHeight)
		.shadow(color: Color("shadow"), radius: 8, x: 2, y: 2)
	}
	
	//MARK: DetailsView UI Constants
	
	private let sinceWhen = "since last month"
	
	private let companyDescriptionWidth: CGFloat = 359
	private let commpanyDescriptionHeight: CGFloat = 138
	
	private let stockPriceWidth: CGFloat = 359
	private let stockPriceHeight: CGFloat = 208
}

//struct DetailsView_Previews: PreviewProvider {
////	@State static var symbol = "TSL"
//    static var previews: some View {
//		DetailsView(stocks: StocksWorker())
//			.preferredColorScheme(.light)
//    }
//}
