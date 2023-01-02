import Foundation

struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let season: Int
    let number: Int?
    let image: TVShowImage?
    let summary: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, season, number, image, summary
    }
    
    var rawSummary: String? {
        summary?.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
    }
}
