import Combine
import Foundation

protocol TVShowListServicing {
    func fetchTVShow(_ url: URL) -> AnyPublisher<[TVShow], Error>
}

struct TVShowListService: TVShowListServicing {
    let fetcher: Fetching = Fetcher()
    
    func fetchTVShow(_ url: URL) -> AnyPublisher<[TVShow], Error> {
        fetcher.fetch(url: url)
    }
}
