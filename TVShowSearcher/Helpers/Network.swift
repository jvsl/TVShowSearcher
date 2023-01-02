import Combine
import Foundation

protocol Fetching {
    func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, Error>
}

struct Fetcher: Fetching {
    
    func fetch<T>(url: URL) -> AnyPublisher<T, Error> where T : Decodable {
        URLSession.shared.dataTaskPublisher(for: url)
            .print()
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
