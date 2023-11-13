//
//  SearchResultContainable.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/09/25.
//

import Foundation

/// 키워드 검색을 통해 받아온 정보를 보관할 수 있는 유형.
protocol SearchResultContainable<Item>: Actor {
    /// 키워드 타입.
    typealias Keyword = KeywordContainable.Keyword
    
    /// 검색 항목 유형.
    associatedtype Item
    
    /// 키워드에 따른 현재 가지고 있는 뉴스 검색 결과를 가져옵니다.
    /// - Parameter keyword: 찾고자 하는 키워드.
    /// - Returns: 현재 뉴스 검색 결과.
    func searchResult(for keyword: Keyword) throws -> any SearchResultProtocol<Item>
    /// 해당 키워드에 추가적인 뉴스 검색 결과를 추가합니다.
    /// - Parameters:
    ///   - searchResult: 추가적 뉴스 검색 결과.
    ///   - keyword: 추가하고자 하는 키워드.
    /// - Returns: 중복된 뉴스 수.
    @discardableResult
    func append(_ searchResult: some SearchResultProtocol<Item>, for keyword: Keyword) throws -> Int
    /// 해당 키워드에 대해 새로운 뉴스 정보로 업데이트합니다.
    /// - Parameters:
    ///   - searchResult: 새로운 뉴스 정보.
    ///   - keyword: 업데이트 할 키워드.
    func update(with searchResult: some SearchResultProtocol<Item>, for keyword: Keyword) throws
    /// 키워드에 대한 검색 결과를 제거합니다.
    /// - Parameter keyword: 제거할 키워드.
    func removeSearchResult(for keyword: Keyword) throws
}
