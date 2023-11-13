//
//  KeywordContainable.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/09/04.
//

/// 키워드를 보관할 수 있는 유형.
protocol KeywordContainable: Actor {
    /// 키워드.
    typealias Keyword = String
    
    /// 키워드 배열.
    var keywords: [Keyword] { get }
    
    /// 키워드를 추가합니다.
    /// - Parameter keyword: 추가하고 싶은 키워드.
    /// - Returns: 추가된 키워드의 인덱스.
    @discardableResult
    func append(_ keyword: Keyword) throws -> Int
    /// 해당 인덱스의 키워드를 삭제합니다.
    /// - Parameter index: 삭제할 키워드의 인덱스.
    /// - Returns: 삭제된 키워드.
    @discardableResult
    func remove(at index: Int) throws -> Keyword
    /// 해당 키워드를 삭제합니다.
    /// - Parameter keyword: 삭제하고 싶은 키워드.
    /// - Returns: 삭제된 키워드.
    @discardableResult
    func remove(_ keyword: Keyword) throws -> Keyword
    /// 키워드의 순서를 바꿉니다.
    /// - Parameters:
    ///   - lhs: 순서를 변경하고 싶은 키워드의 현재 인덱스.
    ///   - rhs: 목적지 인덱스.
    func reorder(from source: Int, to destination: Int) throws
}
