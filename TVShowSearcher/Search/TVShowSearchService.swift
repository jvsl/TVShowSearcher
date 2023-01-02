import Combine
import Foundation

protocol TVShowSearchServicing {
    func search(_ url: URL) -> AnyPublisher<[SerieSearchResponse], Error>
}

struct TVShowSearchService: TVShowSearchServicing {
    let fetcher: Fetching = Fetcher()
    
    func search(_ url: URL) -> AnyPublisher<[SerieSearchResponse], Error> {
        fetcher.fetch(url: url)
    }
}
