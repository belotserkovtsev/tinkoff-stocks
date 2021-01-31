//
//  ContentView.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 29.01.2021.
//

import SwiftUI

struct SearchView: View {
	@EnvironmentObject var stocks: StocksWorker
	@Environment(\.colorScheme) private var colorScheme
	@State private var companySymbol = ""
	@State private var moveToNextScreen = false
	@State private var displayAlert = false
	@State private var displayProgress = false
	
    var body: some View {
		VStack(spacing: .zero) {
			Image(colorScheme == .dark ? "files" : "filesWhite")
				.padding(.bottom, 40)
			
			textBlockView
				.padding(.bottom, 30)
			
			searchFieldView
				.padding(.bottom, 13)
			
			Button(action: {
				displayProgress = true
				
				stocks.getStock(for: companySymbol) { res in
					switch res {
					case .success:
						moveToNextScreen.toggle()
					case .failure(let err):
						if alertToDisplay == nil && !displayAlert {
							alertToDisplay = makeExceptionAlert(with: err.message)
							displayAlert = true
						}
						print(err)
					}
					displayProgress = false
				}
			}){ buttonView }
		}
		.alert(isPresented: $displayAlert) { alertToDisplay! }
		.navigate(
			to: DetailsView(stocks: stocks),
			when: $moveToNextScreen,
			fromName: "Search",
			toName: companySymbol.uppercased().trimmingCharacters(in: .whitespaces)
		)
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
	
	//MARK: SearchView UI Elements
	
	private var textBlockView: some View {
		VStack(spacing: 16) {
			Text("What company are you looking for?")
				.font(.system(size: 26, weight: .semibold))
			Text("Search for a company ticker and find results on the next screen")
				.font(.system(size: 17, weight: .light))
				.foregroundColor(Color("lightGray"))
		}
		.frame(width: textBlockWidth, height: textBlockHeight)
		.multilineTextAlignment(.center)
	}
	
	private var searchFieldView: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(Color("darkGray"))
			HStack(spacing: 5) {
				if displayProgress {
					ProgressView()
						.frame(width: 22, height: 22)
				} else {
					Image(systemName: "magnifyingglass")
						.frame(width: 22, height: 22)
				}
				TextField(searchPlaceholder, text: $companySymbol)
					
			}.padding(.leading, 10)
			
			
		}
		.frame(
			width: searchWidth,
			height: searchHeight,
			alignment: .leading
		)
	}
	
	private var buttonView: some View {
		Text("Continue")
	}
	
	//MARK: UI Constants
	
	private var searchWidth: CGFloat = 344
	private var searchHeight: CGFloat = 36
	private var searchPlaceholder = "Search"
	
	private var buttonWidth: CGFloat = 300
	private var buttonHeight: CGFloat = 50
	
	private var textBlockWidth: CGFloat = 337
	private var textBlockHeight: CGFloat = 122
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
		SearchView()
			.preferredColorScheme(.dark)
    }
}
