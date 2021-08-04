//
//  ViewModel.swift
//  Combine-SearchFeature
//
//  Created by Christian Leovido on 04/08/2021.
//

import Combine
import SwiftUI

final class SearchViewModel: ObservableObject {

	let allConcepts: CurrentValueSubject<[Concept], Never> = CurrentValueSubject([
		Concept(name: "Albert"),
		Concept(name: "Chloe"),
		Concept(name: "Berto"),
		Concept(name: "Diane")
	])

	@Published var searchText = ""
	@Published var searchResults: [Concept] = []

	private(set) var subscriptions: Set<AnyCancellable>! = Set<AnyCancellable>()

	init() {
		setupSearchTextBinding()
	}

	/// This setup function creates two listeners and will listen to event changes on `searchText`. The dollar sign converts it into a `Publisher` type, giving you access to all the operators and benefits of a `Publisher`
	func setupSearchTextBinding() {

		// Runs the code when the searchText is not empty. This will continue and run the next pipelines.
		$searchText
			.filter({ !$0.isEmpty })
			/// The debounce operator delays the execution and cancels any other request made immediately after. This ensures that only one search query is made before continuing down the pipeline. Usually, 0.50, which is 500ms, is the recommended time for optimal UI searching.
			.debounce(for: 0.50, scheduler: DispatchQueue.main)
			.map { searchText in
				self.allConcepts.value.filter({
					$0.name.contains(searchText)
				})
			}
			.sink(receiveValue: { newSearchedConcepts in
				self.searchResults = newSearchedConcepts
			})
			.store(in: &subscriptions)

		/// This publisher runs when the `searchText` is empty. This assigns all the concepts as the `searchResults`
		$searchText
			.filter({ $0.isEmpty })
			.sink { _ in
				self.searchResults = self.allConcepts.value
			}
			.store(in: &subscriptions)
	}
}
