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
		VStack(spacing: .zero) {
			if let data = stocks.stockToDisplay {
				
				companyDescriptionView(for: data)
					.padding(.top, 96)
					.padding(.bottom, 83)
				
				latestPriceView(for: data)
					.padding(.bottom, 18)
				
				changeView(for: data)
					.padding(.bottom)
				
				Button(action: {
					stocks.addCurrentStockToFavourite()
				}, label: { Text("Add to favorite") })
				
				Spacer()
				
			} else {
				EmptyView()
			}
		}
		
        
    }
	
	//MARK: DetailsView UI Elements
	
	private func companyDescriptionView(for data: StockData) -> some View {
		VStack(spacing: .zero) {
			Text(data.companyName)
				.font(.system(size: 16, weight: .light))
				.foregroundColor(Color("darkGray2"))
				.padding(.bottom, 4)
				
			
			Text(data.symbol)
				.font(.system(size: 22, weight: .semibold))
				.foregroundColor(Color("lightGray"))
				
		}
	}
	
	private func latestPriceView(for data: StockData) -> some View {
		Text("$ \(String(format: "%.2f", data.latestPrice))")
			.font(.system(size: 44, weight: .regular))
			.foregroundColor(Color("lightGray"))
			
	}
	
	private func changeView(for data: StockData) -> some View {
		HStack {
			Image(systemName: data.change >= 0 ? "arrow.up" : "arrow.down")
				.frame(width: 14, height: 14)
			Text("\(String(format: "%.2f", data.change)) %")
				.font(.system(size: 16, weight: .medium))
			Text(sinceWhen)
				.font(.system(size: 16, weight: .light))
				.opacity(0.6)
		}
	}
	
	//MARK: DetailsView UI Constants
	
	private let sinceWhen = "since last month"
}

//struct DetailsView_Previews: PreviewProvider {
////	@State static var symbol = "TSL"
//    static var previews: some View {
//        DetailsView()
//    }
//}
