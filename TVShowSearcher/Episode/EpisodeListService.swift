import Combine
import Foundation

protocol EpisodeListServicing {
    func fechEpisodes(url: URL) -> AnyPublisher<[Episode], Error>
}

struct EpisodeListService: EpisodeListServicing {
    let fetcher: Fetching = Fetcher()
    
    func fechEpisodes(url: URL) -> AnyPublisher<[Episode], Error> {
        fetcher.fetch(url: url)
    }
}
