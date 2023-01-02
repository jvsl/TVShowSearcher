import Foundation
import SwiftUI

struct TVShowSearchView: View {
    @StateObject var viewModel = TVShowSearchViewModel()
    @State private var searchText = ""
    
    var body: some View {
        List(viewModel.items, id: \.self) { item in
            NavigationLink(
                destination: DetailView(movie: item.show)) {
                    Text(item.show.name)
                }
        }
        .navigationTitle("searchNavigationTitle")
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $searchText, placement: .automatic, prompt: "search")
        .sync($viewModel.searchText, with: $searchText)
    }
}
