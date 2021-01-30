//
//  FavouritesView.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 30.01.2021.
//

import SwiftUI

struct FavouritesView: View {
	@EnvironmentObject var stocks: StocksWorker
	
    var body: some View {
		VStack {
			ForEach(stocks.favourites, id: \.self) { stock in
				Text(stock.symbol)
				Text(stock.companyName)
				Text(String(stock.latestPrice))
				Text(String(stock.change))
				
				Divider()
			}
			
//			if let data = stocks.stockToDisplay {
//				Text(data.symbol)
//				Text(data.companyName)
//				Text(String(data.latestPrice))
//				Text(String(data.change))
//				Button(action: {
//					stocks.addCurrentStockToFavourite()
//				}, label: {
//					Text("Add to favorite")
//				})
//			} else {
//				EmptyView()
//			}
		}
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
