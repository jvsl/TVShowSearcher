import Combine
import Foundation

protocol TVShowDetailServicing {
    func fetchSeaons(url: URL) -> AnyPublisher<[Season], Error>
}

struct TVShowDetailService: TVShowDetailServicing {
    let fetcher: Fetching = Fetcher()
    
    func fetchSeaons(url: URL) -> AnyPublisher<[Season], Error> {
        fetcher.fetch(url: url)
    }
}
