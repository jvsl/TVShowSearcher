import Combine
import Foundation

class TVShowListViewModel: ObservableObject {
    @Published var items = [TVShow]()
    @Published var state: LoadingState = .none
    private var nextPage = 1
    private var canLoadMorePages = true
    private var thresholdIndexOffset = -5
    private let service: TVShowListServicing
    var cellLoading = false
    var currentPage: Int {
        nextPage == 1 ? nextPage : nextPage - 1
    }
    
    init(service: TVShowListServicing = TVShowListService()) {
        self.service = service
        loadContent()
    }
    
    func loadContent() {
        
        guard state != .initialLoading && canLoadMorePages else {
            return
        }
        
        guard let url = URL(string: Endpoints.tvShowList.add(nextPage)) else { return }
        
        if isFirstPage() {
            state = .initialLoading
        } else  {
            cellLoading = true
        }
    
        fetchTVShows(url)
    }
    
    func callNextPageIfNeeded(currentItem item: TVShow?) {
        
        guard let item = item else {
            loadContent()
            return
        }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: thresholdIndexOffset)
        
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadContent()
        }
    }
    
    private func fetchTVShows(_ url: URL) {
        service.fetchTVShow(url)
            .handleEvents(receiveOutput: { response in
                self.handleSuccess(response)
            })
            .map({ response in
                self.items + response
            })
            .catch({ error in
                self.handleErrors()
            })
            .assign(to: &$items)
    }
    
    private func isReponseAndItemsEmpty(_ response: [TVShow]) -> Bool {
        response.isEmpty && items.isEmpty
    }
    
    private func areItemsFromPaginatedResponseFinished(_ response: [TVShow]) -> Bool {
        response.isEmpty && !self.items.isEmpty
    }
    
    private func handleSuccess(_ response: [TVShow]) {
        canLoadMorePages = !response.isEmpty
        
        if isReponseAndItemsEmpty(response) {
            state = .error
        } else if areItemsFromPaginatedResponseFinished(response) {
            cellLoading = false
        } else {
            state = .success
            nextPage += 1
            cellLoading = true
        }
    }
    
    private func handleErrors() -> Just<[TVShow]>   {
        self.state = .error
        self.canLoadMorePages = false
        
        return Just(self.items)
    }
    
    private func isFirstPage() -> Bool {
        nextPage == 1
    }
}
