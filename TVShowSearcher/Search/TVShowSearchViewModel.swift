import Combine
import Foundation

class TVShowSearchViewModel: ObservableObject {
    @Published var items = [SerieSearchResponse]()
    @Published var searchText = ""
    private var subscription: Set<AnyCancellable> = []
    private let service: TVShowSearchServicing
    
    init(service: TVShowSearchServicing = TVShowSearchService()) {
        self.service = service
        bindSearchText()
    }
    
    func searchItems(searchText: String) {
        let query = searchText.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: Endpoints.tvShowSearch.add(query)) else { return }
        
        service.search(url)
            .sink { (_) in
            } receiveValue: { [weak self] items in
                self?.items = items
            }.store(in: &subscription)
    }
    
    private func bindSearchText() {
        $searchText
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {
                    self.items = []
                    return nil
                }
                return string
            })
            .compactMap{ $0 }
            .sink { (_) in
            } receiveValue: { [self] (searchField) in
                searchItems(searchText: searchField)
            }.store(in: &subscription)
    }
}
