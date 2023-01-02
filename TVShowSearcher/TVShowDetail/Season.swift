import Foundation

struct Season: Codable, Hashable, Equatable {
    let id: Int
    let url: String?
    let number: Int?
    let name: String?
    let episodeOrder: Int?
    let summary: String?
    let image: TVShowImage?
    
    static func == (lhs: Season, rhs: Season) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    enum CodingKeys: String, CodingKey {
        case id, url, number, name, episodeOrder, image, summary
    }
}

