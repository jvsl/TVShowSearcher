import Foundation

struct TVShow: Codable, Identifiable, Hashable {
    let id: Int
    let url: String
    let name: String
    let genres: [String]
    let schedule: Schedule
    let image: TVShowImage?
    let summary: String?
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: TVShow, rhs: TVShow) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id, url, name, genres, schedule, image, summary
    }
}

struct TVShowImage: Codable {
    let medium, original: String
    
    var mediumURL: URL? {
        URL(string: medium)
    }
    
    var originalURL: URL? {
        URL(string: original)
    }
}

struct Schedule: Codable {
    let time: String
    let days: [String]
}

struct SerieSearchResponse: Codable, Hashable {
    let score: Double
    let show: TVShow
}
