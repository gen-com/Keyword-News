//
//  KeywordStorage.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/08/27.
//

import Foundation

/// 키워드 저장소를 표현한 모델.
actor KeywordStorage: Persistable {
    typealias Keyword = KeywordContainable.Keyword
    
    /// 키워드 데이터를 저장할 주소 문자열.
    private static let storagePathString = "keywords.data"
    
    /// 키워드 데이터를 저장할 URL.
    private static var storageURL: URL {
        get throws {
            try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            .appendingPathComponent(storagePathString)
        }
    }
    
    // MARK: - Persistable Conformance
    
    func save(_ content: some Codable) throws {
        let data = try JSONEncoder().encode(content)
        let outfile = try Self.storageURL
        try data.write(to: outfile)
    }
    
    func load() throws -> some Codable {
        let storageURL = try Self.storageURL
        guard let data = try? Data(contentsOf: storageURL)
        else { return [Keyword]() }
        return try JSONDecoder().decode([Keyword].self, from: data)
    }
    
    func reset() throws {
        let storageURL = try Self.storageURL
        try FileManager.default.removeItem(at: storageURL)
    }
}
