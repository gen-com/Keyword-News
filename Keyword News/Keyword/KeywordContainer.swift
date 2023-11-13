//
//  KeywordContainer.swift
//  KeywordNews
//
//  Created by Byeongjo Koo on 2023/09/25.
//

import OrderedCollections

/// 키워드 보관소를 표현한 모델.
actor KeywordContainer: KeywordContainable {
    /// 순서를 가지고 중복을 허용하지 않는 키워드 보관 자료구조.
    private var keywordOrderedSet: OrderedSet<Keyword>
    
    /// 빈 키워드 보관소를 생성합니다.
    init(keywords: [Keyword] = []) {
        keywordOrderedSet = OrderedSet(keywords)
    }
    
    // MARK: - Containable conformance
    
    var keywords: [Keyword] { Array(keywordOrderedSet) }
    
    @discardableResult
    func append(_ keyword: Keyword) throws -> Int {
        let (inserted, index) = keywordOrderedSet.append(keyword)
        if inserted == false { throw Error.redundantKeyword(keyword) }
        return index
    }
    
    @discardableResult
    func remove(at index: Int) throws -> Keyword {
        try checkAccessible(to: index)
        return keywordOrderedSet.remove(at: index)
    }
    
    @discardableResult
    func remove(_ keyword: Keyword) throws -> Keyword {
        guard let removedKeyword = keywordOrderedSet.remove(keyword)
        else { throw Error.keywordNotFound(keyword) }
        return removedKeyword
    }
    
    func reorder(from current: Int, to destination: Int) throws {
        try checkAccessible(to: current)
        try checkAccessible(to: destination)
        let targetKeyword = try remove(at: current)
        keywordOrderedSet.insert(targetKeyword, at: destination)
    }
    
    /// 접근 가능한 인덱스인지 확인합니다.
    /// - Parameter index: 확인할 인덱스.
    private func checkAccessible(to index: Int) throws {
        let validRange = 0..<keywordOrderedSet.count
        guard validRange ~= index
        else { throw Error.invalidAccess(index, validRange) }
    }
    
    // MARK: - Error
    
    /// 키워드 자료구조에서 발생할 수 있는 오류를 정의합니다.
    enum Error: Swift.Error, CustomStringConvertible {
        /// 유효하지 않는 접근.
        ///
        /// 접근하려 했던 인덱스와 유효한 범위를 제공받아 적절한 오류 메시지를 생성할 수 있습니다.
        case invalidAccess(Int, Range<Int>)
        /// 존재하지 않는 키워드.
        ///
        /// 찾으려 했던 키워드를 제공받아 오류 메시지를 생성할 수 있습니다.
        case keywordNotFound(String)
        /// 이미 존재하는 키워드.
        ///
        /// 추가하려 했던 키워드를 제공받아 오류 메시지를 생성할 수 있습니다.
        case redundantKeyword(String)
        
        /// 오류 내용에 대한 설명.
        var description: String {
            switch self {
            case .invalidAccess(let index, let range):
                return "Index \"\(index)\" is not within \(range)."
            case .keywordNotFound(let keyword):
                return "Keyword \"\(keyword)\" is not exists in keyword container."
            case .redundantKeyword(let keyword):
                return "Keyword \"\(keyword)\" is already exists in keyword container."
            }
        }
    }
}
