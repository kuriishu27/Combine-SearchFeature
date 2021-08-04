//
//  ContentView.swift
//  Combine-SearchFeature
//
//  Created by Christian Leovido on 04/08/2021.
//

import SwiftUI
import Combine

struct ContentView: View {
	@StateObject var viewModel: SearchViewModel = SearchViewModel()

	var body: some View {
		NavigationView {
			List(viewModel.searchResults, id: \.name) { item in
				Text(item.name)
			}
			.navigationTitle("Search")
			.navigationBarSearch($viewModel.searchText)
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
