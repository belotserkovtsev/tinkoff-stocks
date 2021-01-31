//
//  FavouritesView.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 30.01.2021.
//

import SwiftUI

struct FavouritesView: View {
	@EnvironmentObject var stocks: StocksWorker
	@State private var displayAlert = false
	@State private var displayProgress = false
	
    var body: some View {
		NavigationView {
			ScrollView {
				VStack {
					ForEach(stocks.favourites, id: \.self) { stock in
						stockCardView(for: stock)
					}
					Spacer()
				}
				.padding(.top, 24)
			}
			
			.navigationBarTitle("Favourites", displayMode: .inline)
			.navigationBarItems(trailing: refreshButton)
		}
		
		.alert(isPresented: $displayAlert) { alertToDisplay! }
    }
	
	//MARK: Alert factory
	
	@State private var alertToDisplay: Alert?
	
	private func makeExceptionAlert(with text: String) -> Alert {
		Alert(
			title: Text("An error occured"),
			message: Text(text),
			dismissButton: .default(Text("Dismiss")){alertToDisplay = nil}
		)
	}
	
	//MARK: FavouritesView UI Elements
	
	private func stockCardView(for stock: StockData) -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(Color("card"))
			HStack(spacing: .zero) {
				Text(stock.symbol)
					.font(.system(size: 18, weight: .semibold))
				Spacer()
				Text("$ \(String(format: "%.2f", stock.latestPrice))")
					.font(.system(size: 14, weight: .semibold))
					.foregroundColor(Color("darkGray2"))
					.padding(.trailing, 20)
				Image(systemName: stock.change >= 0 ? "arrow.up" : "arrow.down")
					.resizable()
					.foregroundColor(Color("darkGray2"))
					.aspectRatio(contentMode: .fit)
					.frame(width: 10, height: 10)
					.padding(.trailing, 4)
				Text("\(String(format: "%.2f", stock.change / stock.latestPrice * 100)) %")
					.foregroundColor(Color("darkGray2"))
					.font(.system(size: 14, weight: .medium))
			}
			.padding([.leading, .trailing], 16)
			
		}
		.frame(width: stockCardWidth, height: stockCardHeight)
		.shadow(color: Color("shadow"), radius: 8, x: 2, y: 2)
	}
	
	private var refreshButton: some View {
		Button(action: {
			displayProgress = true
			stocks.updateFavourites { res in
				switch res {
				case .success:
					break
				case .failure(let err):
					if alertToDisplay == nil && !displayAlert {
						alertToDisplay = makeExceptionAlert(with: err.message)
						displayAlert = true
					}
					print(err)
				}
				displayProgress = false
			}
		}, label: {
			if displayProgress {
				ProgressView()
					.frame(width: 32, height: 32)
			} else {
				Image(systemName: "arrow.clockwise")
					.frame(width: 32, height: 32)
			}
			
		})
	}
	//MARK: FavouritesView UI Constants
	
	private let stockCardWidth: CGFloat = 354
	private let stockCardHeight: CGFloat = 64
	
	
}

//struct FavouritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavouritesView()
//    }
//}
