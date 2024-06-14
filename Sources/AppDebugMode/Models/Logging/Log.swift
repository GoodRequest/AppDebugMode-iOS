//
//  Log.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 18/09/2024.
//

import Foundation

// MARK: - Log

struct Log: Identifiable, Hashable, Sendable, Codable, RawRepresentable {
    
    var rawValue: String {
        "\(message) \(date) \(id)"
    }
    
    var id: UInt64 {
        absoluteSystemTime
    }
    
    let message: String
    let date: Date
    
    private let absoluteSystemTime: UInt64
    
    init?(rawValue: String) {
        let components = rawValue.split(separator: "|")
        guard components.count == 3 else { return nil }
        
        // Extract message
        self.message = String(components[0])
        
        // Extract date
        let dateString = String(components[1])
        guard let parsedDate = ISO8601DateFormatter().date(from: dateString) else { return nil }
        self.date = parsedDate
        
        // Extract absoluteSystemTime (id)
        guard let idValue = UInt64(components[2]) else { return nil }
        self.absoluteSystemTime = idValue
    }
    
    init(message: String) {
        self.message = message
        self.date = Date()
        self.absoluteSystemTime = mach_absolute_time()
    }
    
    // Custom Coding Keys
    enum CodingKeys: String, CodingKey {
        case message
        case date
        case absoluteSystemTime
    }
    
    // Implement Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(date, forKey: .date)
        try container.encode(absoluteSystemTime, forKey: .absoluteSystemTime)
    }
    
    // Implement Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        date = try container.decode(Date.self, forKey: .date)
        absoluteSystemTime = try container.decode(UInt64.self, forKey: .absoluteSystemTime)
    }
    
}

extension Array: @retroactive RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        #warning("When adding new element don't decode and reencode all the list but just append data")
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
