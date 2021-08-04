//
//  CustomSearchBar.swift
//  Combine-SearchFeature
//
//  Created by Christian Leovido on 04/08/2021.
//

import Combine
import SwiftUI

public extension View {
	func navigationBarSearch(_ searchText: Binding<String>) -> some View {
		return overlay(CustomSearchBar(text: searchText).frame(width: 0, height: 0))
	}
}

struct CustomSearchBar: UIViewControllerRepresentable {

	@Binding var text: String

	init(text: Binding<String>) {
		self._text = text
	}

	func makeUIViewController(context: Context) -> SearchBarWrapperController {
		return SearchBarWrapperController()
	}

	func updateUIViewController(_ controller: SearchBarWrapperController, context: Context) {
		controller.searchController = context.coordinator.searchController
	}

	func makeCoordinator() -> Coordinator {
		return Coordinator(text: $text)
	}

	class Coordinator: NSObject, UISearchResultsUpdating, UISearchBarDelegate {
		@Binding var text: String
		let searchController: UISearchController

		private var subscription: AnyCancellable?

		init(text: Binding<String>) {
			self._text = text
			self.searchController = UISearchController(searchResultsController: nil)
			self.searchController.searchBar.placeholder = "Search..."

			super.init()

			self.searchController.searchBar.delegate = self

			searchController.searchResultsUpdater = self
			searchController.hidesNavigationBarDuringPresentation = true
			searchController.obscuresBackgroundDuringPresentation = false

			self.searchController.searchBar.text = self.text
			self.subscription = self.text.publisher.sink { _ in
				self.searchController.searchBar.text = self.text
			}
		}

		deinit {
			self.subscription?.cancel()
		}

		func updateSearchResults(for searchController: UISearchController) {
			guard let text = searchController.searchBar.text else { return }
			self.text = text
		}
	}

	class SearchBarWrapperController: UIViewController {
		var searchController: UISearchController? {
			didSet {
				self.parent?.navigationItem.searchController = searchController
			}
		}
	}
}
