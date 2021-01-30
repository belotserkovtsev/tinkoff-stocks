//
//  ContentView.swift
//  Tinkoff
//
//  Created by belotserkovtsev on 30.01.2021.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var stocks: StocksWorker
	
    var body: some View {
		TabView {
			SearchView()
				.tabItem {
					Image(systemName: "magnifyingglass")
					Text("Search")
				}
			FavouritesView()
				.tabItem {
					Image(systemName: "suit.heart")
					Text("Favourites")
				}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.preferredColorScheme(.dark)
    }
}
