//
//  Searchable.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/09/25.
//

import Foundation

/// 키워드를 통해 검색을 할 수 있는 유형.
protocol Searchable<Item> {
    /// 검색 키워드.
    typealias Keyword = KeywordContainable.Keyword
    
    /// 검색할 항목 유형.
    associatedtype Item: Codable
    
    /// 키워드에 대한 검색을 수행합니다.
    /// - Parameter parameter: 검색 파라미터.
    /// - Returns: 검색 결과 모음
    static func search(
        for parameter: Encodable,
        with session: URLSession
    ) async throws -> any SearchResultProtocol<Item>
    /// 키워드 모음에 대한 검색을 수행합니다.
    /// - Parameter parameters: 검색 파라미터 모음.
    /// - Returns: 검색 결과 모음
    static func search(
        contentsOf parameters: [Encodable],
        with session: URLSession
    ) async throws -> [any SearchResultProtocol<Item>]
}

extension Searchable {
    static func search(
        for parameter: Encodable,
        with session: URLSession
    ) async throws -> any SearchResultProtocol<Item> {
        try await NaverOpenAPI.Request(path: NaverOpenAPI.Path.news)
            .httpHeader(NaverOpenAPI.authenticationHeader)
            .parameter(parameter)
            .fetch(withSession: session)
            .verifyResponse()
            .decodeJSON(NaverOpenAPI.SearchResult<Item>.self)
    }
    
    static func search(
        contentsOf parameters: [Encodable],
        with session: URLSession
    ) async throws -> [any SearchResultProtocol<Item>] {
        var searchResults = [any SearchResultProtocol<Item>]()
        try await withThrowingTaskGroup(of: (any SearchResultProtocol<Item>).self) { group in
            for parameter in parameters {
                group.addTask { try await search(for: parameter, with: session) }
            }
            for try await searchResult in group {
                searchResults.append(searchResult)
            }
        }
        return searchResults
    }
}

/// 키워드 검색을 구현한 제너릭 모델.
enum Searcher<Item>: Searchable where Item: Codable {}
